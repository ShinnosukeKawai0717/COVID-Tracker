//
//  ViewController.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 11/29/21.
//

import UIKit
import CoreLocation
import MapKit
import FloatingPanel
import ProgressHUD

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewController(_ vc: HomeViewController, didLoad regions: [Region])
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    private let covidDataVC = COVIDDataViewController()
    private let floatingPanel = FloatingPanelController()
    private var regionAnnotations = [RegionAnnotation]()

    public var mapCenter = CLLocationCoordinate2D(){
        didSet {
            self.mapView.setRegion(MKCoordinateRegion(center: self.mapCenter, span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)), animated: true)
        }
    }
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .mutedStandard
        map.register(RegionAnnotationView.self, forAnnotationViewWithReuseIdentifier: RegionAnnotationView.reuseIdentifier)
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMainView()
        initializeFPView()
        initializeMapView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        floatingPanel.addPanel(toParent: self, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    private func initializeMainView() {
        view.addSubview(mapView)
        mapView.delegate = self
        self.delegate = covidDataVC
        self.dismissKeyBoardWhenTappedAround()
        floatingPanel.set(contentViewController: covidDataVC)
        floatingPanel.surfaceView.appearance.cornerRadius = 20
        covidDataVC.getTopHeader().addTargetForMenuButton(target: self, selector: #selector(menuPressed), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCoordinate), name: Notification.Name("region for map center"), object: nil)
    }
    private func initializeMapView() {
        ProgressHUD.show()
        DataManager.shared.loadData { [weak self] regions in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.homeViewController(strongSelf, didLoad: regions)
            strongSelf.createRegionAnnotations(regions)
            ProgressHUD.dismiss()
        }
    }
    @objc func didReceiveCoordinate(_ notification: Notification) {
        let coordinate = notification.object as? Coodinate
        guard let location = coordinate else { return }
        self.mapCenter = location.getCLCoordinate2D()
    }
    private func initializeFPView() {
        LocationManager.shared.getCurrentLocation { location in
            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)), animated: false)
        }
    }
    @objc func menuPressed() {
        floatingPanel.move(to: .full, animated: true, completion: nil)
    }
    
    private func createRegionAnnotations(_ regions: [Region]) {
        var annotations = [RegionAnnotation]()
        for region in regions {
            let region = region
            let title = region.combined_key
            var location = CLLocationCoordinate2D()
            if let coordinate = region.coordinate {
                location = coordinate.getCLCoordinate2D()
            }
            annotations.append(RegionAnnotation(region: region, title: title, coordinate: location))
        }
        self.regionAnnotations = annotations
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is RegionAnnotation else {return nil}
        
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: RegionAnnotationView.reuseIdentifier) as? RegionAnnotationView

        if annotationView == nil{
            annotationView = RegionAnnotationView(annotation: annotation, reuseIdentifier: RegionAnnotationView.reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if let regionAnnotation = annotation as? RegionAnnotation{
            annotationView?.regionAnnotation = regionAnnotation
        } else {
            print("Error: cast to regionAnnotation")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let temp = self.regionAnnotations
        let filteredRegions = temp.map(mapView.filterRegion)
        mapView.superview?.animate {
            self.mapView.addAnnotations(filteredRegions)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let regionAnnotionView = view as? RegionAnnotationView else {
            print("Error: cast failed RegionAnnotationView")
            return
        }
        guard let regionAnnotation = regionAnnotionView.annotation as? RegionAnnotation else {
            print("Error: cast failed RegionAnnotation")
            return
        }
        covidDataVC.getStatsHeader().configureDataLabels(with: regionAnnotation.region)
        covidDataVC.getTopHeader().configureTitle(with: regionAnnotation.region)
        covidDataVC.region = regionAnnotation.region
    }
}

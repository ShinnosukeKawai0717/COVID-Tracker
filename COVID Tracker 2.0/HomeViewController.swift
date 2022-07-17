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
import Disk
import CSV
import ProgressHUD

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewController(_ vc: HomeViewController, didLoad regions: [Region])
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    private let covidDataVC = COVIDDataViewController()
    private let covidStatsFP = FloatingPanelController()
    private var regionAnnotations = [RegionAnnotation]()

    public var mapCenter = CLLocationCoordinate2D(){
        didSet {
            self.mapView.setRegion(MKCoordinateRegion(center: self.mapCenter, span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)), animated: true)
        }
    }
    private var myLocationInfo = MyLocationInfor() {
        didSet {
            self.covidDataVC.getTopHeader().configureTitle(with: self.myLocationInfo.title)
        }
    }
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .mutedStandard
        map.register(RegionAnnotationView.self, forAnnotationViewWithReuseIdentifier: RegionAnnotationView.reuseIdentifier)
        return map
    }()
    private let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.imageView?.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMainView()
        initializeFPView()
        initializeMapView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        setUpLocationButton()
    }
    private func initializeMainView() {
        view.addSubview(mapView)
        view.addSubview(locationButton)
        mapView.delegate = self
        self.dismissKeyBoardWhenTappedAround()
        covidStatsFP.set(contentViewController: covidDataVC)
        covidStatsFP.surfaceView.appearance.cornerRadius = 20
        locationButton.addTarget(self, action: #selector(didTappedLocation), for: .touchUpInside)
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: "regions"), object: regions)
            strongSelf.createRegionAnnotations(regions)
            strongSelf.findMyRegion(regions)
            ProgressHUD.dismiss()
        }
    }
    @objc func didReceiveCoordinate(_ notification: Notification) {
        let coordinate = notification.object as? Coodinate
        guard let location = coordinate else { return }
        self.mapCenter = location.getCLCoordinate2D()
    }
    private func findMyRegion(_ regions: [Region]) {
        var myRegion = Region()
        for result in regions {
            if let myCountry = result.country_region, RegionCode.iso2ToiSO3[myCountry] != nil {
                myRegion = result
                break
            }
        }
        NotificationCenter.default.post(name: Notification.Name("my region"), object: myRegion)
        if let coordinate = myRegion.coordinate {
            self.mapCenter = coordinate.getCLCoordinate2D()
        }
        self.covidDataVC.getTopHeader().configureTitle(with: myRegion)
        self.covidDataVC.getStatsHeader().configureDataLabels(with: myRegion)
    }
    private func initializeFPView() {
        covidStatsFP.addPanel(toParent: self, animated: true)
        LocationManager.shared.getCurrentLocation { location in
            self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.2, longitudeDelta: 1.2)), animated: false)
        }
    }
    private func resolveLocation(with location: CLLocation) {
        LocationManager.shared.resolveLocationName(with: location) { myLocationInfo in
            self.myLocationInfo = myLocationInfo
        }
    }
    @objc func menuPressed() {
        covidStatsFP.move(to: .full, animated: true, completion: nil)
    }
    @objc func didTappedLocation() {
        LocationManager.shared.getCurrentLocation { location in
            LocationManager.shared.resolveLocationName(with: location) { [weak self] myLocationInfo in
                guard let strongSelf = self else {
                    return
                }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                strongSelf.mapCenter = center
                strongSelf.myLocationInfo = myLocationInfo
            }
        }
    }
    private func setUpLocationButton() {
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 60),
            locationButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        locationButton.layer.cornerRadius = locationButton.frame.height / 2
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



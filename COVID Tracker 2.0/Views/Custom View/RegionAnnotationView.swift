//
//  RegionAnnotationView.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 11/30/21.
//

import Foundation
import MapKit
import CloudKit

class RegionAnnotationView: MKAnnotationView {
    
    static let reuseIdentifier = "RegionAnnotationView"
    
    private lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        countLabel.backgroundColor = .clear
        countLabel.font = .boldSystemFont(ofSize: 12)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.minimumScaleFactor = 0.5
        countLabel.baselineAdjustment = .alignCenters
        self.addSubview(countLabel)
        return countLabel
    }()
    
    public var regionAnnotation =  RegionAnnotation() {
        didSet {
            self.configure()
        }
    }
    
    public var zoomLevel = 0.0 {
        didSet {
            self.configure()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.autoresizesSubviews = true
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(aDecoder.debugDescription)
    }
    
    public func configure() {
        
        DispatchQueue.main.async {
            self.countLabel.text = String(self.regionAnnotation.region.actuals?.newCases ?? 0)
            self.frame.size = CGSize(width: 50, height: 50)
            self.layer.cornerRadius = self.frame.height / 2
            self.backgroundColor = .black
        }
        
        self.detailCalloutAccessoryView = DetailsView(model: regionAnnotation.region)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        countLabel.frame = bounds
    }
}

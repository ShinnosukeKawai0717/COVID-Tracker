//
//  RegionPointAnnotation.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 12/4/21.
//

import UIKit
import MapKit

class RegionAnnotation: NSObject, MKAnnotation {
    
    let region: Region
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    override init() {
        self.region = Region()
        self.title = ""
        self.coordinate = CLLocationCoordinate2D()
    }
    
    init(region: Region, title: String, coordinate: CLLocationCoordinate2D) {
        self.region = region
        self.title = title
        self.coordinate = coordinate
    }
}

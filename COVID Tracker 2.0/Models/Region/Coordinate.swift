//
//  Coordinate.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/3/22.
//

import Foundation
import CoreLocation

struct Coodinate: Codable {
    var latitude: Float?
    var longitude: Float?
    
    func getCLCoordinate2D() -> CLLocationCoordinate2D {
        guard let lat = latitude, let long = longitude else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
    }
    
    init() {
        self.latitude = nil
        self.longitude = nil
    }
    
    init(lat: Float, long: Float) {
        self.latitude = lat
        self.longitude = long
    }
}

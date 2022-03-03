//
//  LocationManager.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 11/29/21.
//

import CoreLocation
import Foundation
import UIKit

struct MyLocationInfor: Codable {
    let title: String
    let province: String
    let country: String
    let isoCode2: String
    init() {
        self.title = ""
        self.province = ""
        self.country = ""
        self.isoCode2 = ""
    }
    init(title: String, city: String, country: String, code: String) {
        self.title = title
        self.province = city
        self.country = country
        self.isoCode2 = code
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    enum PlacesError: Error {
        case faildedToFind
        case failedToGetCoordinates
    }
    
    public func getCurrentLocation(completion: @escaping ((CLLocation) -> Void)){
        self.completion = completion
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    public func resolveLocationName(with location: CLLocation, completion: @escaping ((MyLocationInfor) -> Void)) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placeMark, error in
            guard let place = placeMark?.first, error == nil else {
                return 
            }
            var titleString = ""
            var provinceStr = ""
            var countryString = ""  
            var isoCode2 = ""
            if let adminRegion = place.administrativeArea {
                titleString += adminRegion
                provinceStr = adminRegion
            }
            if let isoCode = place.isoCountryCode {
                isoCode2 = isoCode
            }
            if let country = place.country {
                titleString += ", " + country
                countryString = country
            }
            let myLocation = MyLocationInfor(title: titleString, city: provinceStr, country: countryString, code: isoCode2)
            
            completion(myLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        completion?(location)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

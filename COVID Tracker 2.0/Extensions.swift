//
//  Extensions.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/22/22.
//

import Foundation
import UIKit
import MapKit
import Algorithm

extension UIViewController {
    func dismissKeyBoardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MKMapView {
    open var currentZoomLevel: Double {
        let z = log2(360.0 * self.frame.size.width / (self.region.span.longitudeDelta * 128))
        return z
    }
    
    func filterRegion(annotation: RegionAnnotation) -> RegionAnnotation {
        var region = RegionAnnotation()
        if 6.5 <= self.currentZoomLevel && self.currentZoomLevel < 10.0 && annotation.region.regionType == .province_state {
            region = annotation
        }
        if (self.currentZoomLevel < 7.0) && annotation.region.regionType == .country {
            region = annotation
        }
        return region
    }
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval = 0.5) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    public func animate(duration: TimeInterval = 1, animation: @escaping (() -> Void)) {
        UIView.transition(with: self, duration: duration, options: [.transitionCrossDissolve, .allowUserInteraction], animations: animation, completion: nil)
    }
}

extension Array {
    func uniqueElements<T: Hashable>(map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

extension Date {
    static func datesRange(from: Date, to: Date, format: String) -> [String] {
        if from > to { return [String]() }

        var tempDate = from
        var array = [String]()

        while tempDate < to {
            array.append(tempDate.getFormattedDate(format: format))
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        }
        array.append(to.getFormattedDate(format: format))

        return array
    }
    
    static func mapHeader(_ header: [String]) -> [String] {
        let dates = Array(header[4..<header.count])
        return dates
    }
    static func convertFromStr(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy/M/d"
        
        return dateFormatter.date(from: dateStr)!
    }
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

extension Nation {
    var combined_key: String {
        if let province_state = self.province_state, !province_state.isEmpty {
            if let usState = RegionCode.states[province_state] {
                return "\(usState), USA"
            }
            return "\(province_state), \(country_region ?? "")"
        }
        return self.country_region ?? ""
    }
}

extension Region {    
    static func createFromTimeSeries(_ raw: [String]) -> Region {
        let province_state = raw[DataFeild.province_state.rawValue]
        let country_region = raw[DataFeild.country_region.rawValue]
        var regionType: RegionType = .country
        if !province_state.isEmpty {
            regionType = .province_state
        }
        let lat = Float(raw[DataFeild.latitude.rawValue]) ?? 0.0
        let long = Float(raw[DataFeild.longtitude.rawValue]) ?? 0.0
        let coordinate = Coodinate(lat: lat, long: long)
        return Region(province_state: province_state, couuntry_region: country_region, coordinate: coordinate, regionType: regionType)
    }
    static func createRegions(names: [String], datas: [[String:Queue<(String, Int)>]?]) -> [Region] {
        var prefectures = [Region]()
        let newCases = datas[0]!
        let totalCases = datas[1]!
        let newdeaths = datas[2]!
        let totalDeaths = datas[3]!
        for name in names {
            let prefecture = Region()
            prefecture.province_state = name
            prefecture.country_region = "Japan"
            prefecture.regionType = .province_state
            
            if var newCases = newCases[name] {
                
            }
            if var cumultiveCases = totalCases[name] {
                
            }
            if var newDeaths = newdeaths[name] {
                
            }
            if var culmutiveDeaths = totalDeaths[name] {
                
            }
            
            prefectures.append(prefecture)
        }
        return prefectures
    }
}

extension Collection {
    static func createFromArrDict<T: Codable>(dict: [String:[T]], tuple: (String, [T])) -> [String : [T]] {
        var result = dict
        let key = tuple.0
        let value = tuple.1
        result[key] = value
        return result
    }
    
    static func createFromArrDict<T: Codable>(dict: [String: T], tuple: (String, T)) -> [String : T] {
        var result = dict
        let key = tuple.0
        let value = tuple.1
        result[key] = value
        return result
    }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}



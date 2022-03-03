//
//  Region.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/30/22.
//

import Foundation
import CSV
import CoreText

protocol Nation {
    var province_state: String? { get set }
    var country_region: String? { get set }
    var coordinate: Coodinate? { get set }
}

public class Country {
    var name: String?
    var province_state: String?
    var regionType: RegionType?
    var coordinate: Coodinate
    var statistic: Statistic?
    var dailyData: DailyData?
    
    init() {
        self.province_state = nil
        self.name = nil
        self.coordinate = Coodinate()
        self.statistic = nil
        self.regionType = nil
        self.dailyData = nil
    }
}

public class Region: NSObject, Codable, Nation {
    var province_state: String?
    var country_region: String?
    var coordinate: Coodinate?
    var actuals: Actuals?
    var actualsTimeseries: [Timeseries]
    var regionType: RegionType?
    
    private enum CodingKeys: String, CodingKey {
        case province_state = "state"
        case country_region = "country"
        case actuals, actualsTimeseries
    }
    
    override init() {
        self.actualsTimeseries = []
    }
    
    init(province_state: String, couuntry_region: String, coordinate: Coodinate, regionType: RegionType) {
        self.province_state = province_state
        self.country_region = couuntry_region
        self.coordinate = coordinate
        self.regionType = regionType
        self.actualsTimeseries = []
    }
    
    init(province_state: String, couuntry_region: String, coordinate: Coodinate, timeseries: [Timeseries], regionType: RegionType) {
        self.province_state = province_state
        self.country_region = couuntry_region
        self.coordinate = coordinate
        self.actualsTimeseries = timeseries
        self.regionType = regionType
    }
    
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        province_state = try container.decode(String?.self, forKey: .province_state)
        country_region = try container.decode(String?.self, forKey: .country_region)
        actuals = try container.decode(Actuals.self, forKey: .actuals)
        actualsTimeseries = try container.decode([Timeseries].self, forKey: .actualsTimeseries)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(province_state, forKey: .province_state)
        try container.encode(country_region, forKey: .country_region)
        try container.encode(actuals, forKey: .actuals)
        try container.encode(actualsTimeseries, forKey: .actualsTimeseries)
    }
    
    static func createNewUSA(usa: Region) -> Region {
        let coordinate = Const.CountryData.USA.getCoordinate(state: usa.province_state ?? "")
        usa.coordinate = coordinate ?? Coodinate(lat: 0.0, long: 0.0)
        usa.regionType = .province_state
        return usa
    }
}

struct Actuals: Codable {
    var cases: Int?
    var deaths: Int?
    var newCases: Int?
    var newDeaths: Int?
    
    static func createActualsConfirmed(_ raw: [String]) -> [String : Actuals] {
        var actuals = Actuals()
        var key = raw[1]
        if !raw[0].isEmpty { key = "\(raw[0]), \(raw[1])"}
        let cases = Int(raw[raw.count-1]) ?? 0
        let newCases = (Int(raw[raw.count-1]) ?? 0) - (Int(raw[raw.count-2]) ?? 0)
        actuals.cases = cases
        actuals.newCases = newCases
        return [key : actuals]
    }
    
    static func createActualsDeath(_ raw: [String]) -> [String : Actuals] {
        var actuals = Actuals()
        var key = raw[1]
        if !raw[0].isEmpty { key = "\(raw[0]), \(raw[1])"}
        let deaths = Int(raw[raw.count-1]) ?? 0
        let newDeaths = (Int(raw[raw.count-1]) ?? 0) - (Int(raw[raw.count-2]) ?? 0)
        actuals.deaths = deaths
        actuals.newDeaths = newDeaths
        return [key : actuals]
    }
}

struct Timeseries: Codable {
    var cases: Int?
    var deaths: Int?
    var newCases: Int?
    var newDeaths: Int?
    var date: String?
    
    static func createConfirmedList(_ raw: [String]) -> [String : [Timeseries]] {
        
        var value = [Timeseries]()
        var key = raw[1]
        
        if !raw[0].isEmpty { key = "\(raw[0]), \(raw[1])" }
        let dates = Array(raw[4..<raw.count])
        value = dates.enumerated().map { (index, data) -> Timeseries in
            let total = Int(dates[index]) ?? 0
            let current = Int(dates[index]) ?? 0
            var previus = 0
            if dates.indices.contains(index-1) {
                previus = Int(dates[index-1]) ?? 0
            }
            var new = current - previus
            if new.signum() == -1 { new = 0 }
            return Timeseries(cases: total, deaths: nil, newCases: new, newDeaths: nil, date: nil)
        }
        return [key : value]
    }
    
    static func createDeathList(_ raw: [String]) -> [String : [Timeseries]] {
        
        var value = [Timeseries]()
        var key = raw[1]
        
        if !raw[0].isEmpty { key = "\(raw[0]), \(raw[1])" }
        let dates = Array(raw[4..<raw.count])
        value = dates.enumerated().map { (index, data) -> Timeseries in
            let total = Int(dates[index]) ?? 0
            let current = Int(dates[index]) ?? 0
            var previus = 0
            if dates.indices.contains(index-1) {
                previus = Int(dates[index-1]) ?? 0
            }
            var new = current - previus
            if new.signum() == -1 { new = 0 }
            return Timeseries(cases: nil, deaths: total, newCases: nil, newDeaths: new, date: nil)
        }
        return [key : value]
    }
}

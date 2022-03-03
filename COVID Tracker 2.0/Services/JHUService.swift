//
//  JHUService.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/30/22.
//

import Foundation
import CSV
import FloatingPanel
import ProgressHUD
import Charts

class JHUService: DataService {
    static let shared = JHUService()
    var completion: (([Region]) -> Void)?
    let baseURL = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/"
    let time_series_covid19_confirmed_global = "csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
    let time_series_covid19_deaths_global = "csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
     
    public func fetchGlobalData(completion: @escaping (([Region]) -> Void)) {
        self.completion = completion
        let dispatchGroup = DispatchGroup()
        var data = [Data?](repeating: nil, count: 3)
        
        dispatchGroup.enter()
        requestData(baseURL + time_series_covid19_confirmed_global) { result in
            data[0] = result
            dispatchGroup.leave()
            print("successfully downloaded confirmed global")
        }
        
        dispatchGroup.enter()
        requestData(baseURL + time_series_covid19_deaths_global){ result in
            data[1] = result
            dispatchGroup.leave()
            print("successfully downloaded death global")
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.parseTimeSeries(data)
        }
    }
    
    private func parseTimeSeries(_ data: [Data?]) {
        guard let confirmedTimeSeries = data[0] else {
            return
        }
        guard let deathTimeSeries = data[1] else {
            return
        }
        
        let (regions, dates, confirmed, actualConfirmed) = self.parseData(confirmedTimeSeries, for: .confirmed)
        let (_, _, deaths, actualDeath) = self.parseData(deathTimeSeries, for: .death)
        
        
        let confirmedDict = confirmed.flatMap({$0}).reduce([String : [Timeseries]](), Dictionary<String, Any>.createFromArrDict)
        let deathDict = deaths.flatMap({$0}).reduce([String : [Timeseries]](), Dictionary<String, Any>.createFromArrDict)
       
        // combine death actual timesries and confirmed case actual timeseries
       let actuals = actualConfirmed.map { (key, actualConfirmed) -> [String:Actuals] in
            var result = actualConfirmed
            if let death = actualDeath[key] {
                result.newDeaths = death.newDeaths
                result.deaths = death.deaths
            }
            return [key:result]
        }.flatMap({$0}).reduce([String:Actuals](), Dictionary<String, Any>.createFromArrDict)
        
        // combine death timeseries and confirmed case timeseries
        let timeseries = confirmedDict.map { (key, confirmed) -> [String:[Timeseries]] in
            var result = confirmed
            if let deaths = deathDict[key] {
                result = confirmed.enumerated().map { (index, confirmed) -> Timeseries in
                    var pastData = confirmed
                    pastData.newDeaths = deaths[index].newDeaths
                    pastData.deaths = deaths[index].deaths
                    return pastData
                }
            }
            return [key : result]
        }.flatMap({$0}).reduce([String:[Timeseries]](), Dictionary<String, Any>.createFromArrDict)
        
        // assign all timeseries to regions
        let newRegions = self.combineTimeseries(region: regions, actualTimeseries: timeseries, actuals: actuals)
        
        // assign dates to timeseries
        let completeRegions = newRegions.map { region -> Region in
            let newTimeses = region.actualsTimeseries.enumerated().map { (index, timeseries) -> Timeseries in
                var mutableTimeseries = timeseries
                mutableTimeseries.date = dates![index]
                return mutableTimeseries
            }
            region.actualsTimeseries = newTimeses
            return region
        }
        
        print("finished parsing")
        DispatchQueue.global().async {
            self.completion?(completeRegions)
        }
    }
    
    private func combineTimeseries(region: [Region], actualTimeseries: [String:[Timeseries]], actuals: [String : Actuals]) -> [Region] {
        let result = region.map { region -> Region in
            if let actualsTimeseries = actualTimeseries[region.combined_key] {
                region.actualsTimeseries = actualsTimeseries
            }
            if let actuals = actuals[region.combined_key] {
                region.actuals = actuals
            }
            return region
        }
        return result
    }
    
    private func parseData(_ data: Data, for kind: DataFeild) -> ( [Region], [String]?, [[String : [Timeseries]]], [String:Actuals] ) {
        var regions = [Region]()
        do {
            let reader1 = try CSVReader(string: String(data: data, encoding: .utf8)!, hasHeaderRow: true)
            let header = reader1.headerRow.map(Date.mapHeader)
            
            regions = reader1.map(Region.createFromTimeSeries)
            
            let reader2 = try CSVReader(string: String(data: data, encoding: .utf8)!, hasHeaderRow: true)
            let reader3 = try CSVReader(string: String(data: data, encoding: .utf8)!, hasHeaderRow: true)
            
            switch kind {
            case .confirmed:
                let confirmed = reader2.map(Timeseries.createConfirmedList)
                let actualConfirmed = reader3.map(Actuals.createActualsConfirmed).flatMap({$0}).reduce([String:Actuals](), Dictionary<String, Any>.createFromArrDict)
                
                return (regions, header, confirmed, actualConfirmed)
            case .death:
                let death = reader2.map(Timeseries.createDeathList)
                let actualDeath = reader3.map(Actuals.createActualsDeath).flatMap({$0}).reduce([String:Actuals](), Dictionary<String, Any>.createFromArrDict)
                
                return (regions, header, death, actualDeath)
            default:
                return (regions, header, [], [:])
            }
        } catch {
            print(error)
        }
        return (regions, [], [], [:])
    }
}

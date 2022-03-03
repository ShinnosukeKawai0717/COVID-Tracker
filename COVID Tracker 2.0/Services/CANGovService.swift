//
//  CanadaGovService.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/11/22.
//

import Foundation
import CSV

public class CANGovService {
    static let shared = CANGovService()
    
    let canadaCoordinate = Coodinate(lat: 56.130366, long: -106.346771)
    
    public func fetchCanadaData(completion: @escaping ((Region) -> Void)) {
        // https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv
        URLSession.shared.dataTask(with: URL(string: "https://health-infobase.canada.ca/src/data/covidLive/covid19-download.csv")!) { data, _, error in
            if let data = data {
                do {
                    let reader1 = try CSVReader(string: String(data: data, encoding: .utf8)!, hasHeaderRow: true).filter({return $0[0] == "1"})
                    let canada = reader1.map(self.mapRaw)
                    let reducedCAN = canada.reduce(canada.first ?? canada[0], self.reduce)
                    
                    DispatchQueue.global().async {
                        completion(reducedCAN)
                    }
                } catch {
                    print(error)
                }
            }
            else if let error = error {
                print(error)
            }
        }.resume()
    }
    
    func reduce(partialResult: Region, region: Region) -> Region {
        partialResult.actualsTimeseries.append(region.actualsTimeseries[0])
        let cases = region.actualsTimeseries[0].cases
        let newCases = region.actualsTimeseries[0].newCases
        let deaths = region.actualsTimeseries[0].deaths
        let newDeaths = region.actualsTimeseries[0].newDeaths
        partialResult.actuals = Actuals(cases: cases, deaths: deaths, newCases: newCases, newDeaths: newDeaths)
        return partialResult
    }
    
    func mapRaw(raw: [String]) -> Region {
        let date = raw[3]
        let totalCases = Int(raw[5])
        let totalDeath = Int(raw[7])
        let newCases = Int(raw[15])
        let newDeaths = Int(raw[19])

        var actualTimeseries = [Timeseries]()
        let timeseries = Timeseries(cases: totalCases, deaths: totalDeath, newCases: newCases, newDeaths: newDeaths, date: date)
        actualTimeseries.append(timeseries)
        return Region(province_state: "", couuntry_region: "Canada", coordinate: self.canadaCoordinate, timeseries: actualTimeseries, regionType: .country)
    }
}

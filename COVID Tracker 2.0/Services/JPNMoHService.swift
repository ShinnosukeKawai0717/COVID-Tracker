//
//  MOJService.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/15/22.
//

import Foundation
import CSV
import Algorithm

class JPNMoHService: DataService {
    let newly_confirmed_cases_daily = "https://covid19.mhlw.go.jp/public/opendata/newly_confirmed_cases_daily.csv"
    let confirmed_cases_cumulative_daily = "https://covid19.mhlw.go.jp/public/opendata/confirmed_cases_cumulative_daily.csv"
    let deaths_cumulative_daily = "https://covid19.mhlw.go.jp/public/opendata/deaths_cumulative_daily.csv"
    let number_of_deaths_daily = "https://covid19.mhlw.go.jp/public/opendata/number_of_deaths_daily.csv"
    let requiring_inpatient_care_etc_daily = "https://covid19.mhlw.go.jp/public/opendata/requiring_inpatient_care_etc_daily.csv"
    
    static let shared = JPNMoHService()
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        var result = [Data?](repeating: nil, count: 5)
        dispatchGroup.enter()
        requestData(newly_confirmed_cases_daily) { data in
            result[0] = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        requestData(confirmed_cases_cumulative_daily) { data in
            result[1] = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        requestData(deaths_cumulative_daily) { data in
            result[2] = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        requestData(number_of_deaths_daily) { data in
            result[3] = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        requestData(requiring_inpatient_care_etc_daily) { data in
            result[4] = data
            dispatchGroup.leave()
        }
        
//        dispatchGroup.notify(queue: .global()) {
//            self.parseData(result)
//        }
    }
    
//    func parseData(_ data: [Data?]) {
//        guard let dailyConfirmedCases = data[0] else { return }
//        guard let cumulativeConfirmedCases = data[1] else { return }
//        guard let cumulativeDeath = data[2] else { return }
//        guard let dailyDeath = data[3] else { return }
//        guard let cumulativeRecovered = data[4] else { return }
//        do {
//            let reader1 = try CSVReader(string: String(data: dailyConfirmedCases, encoding: .utf8)!, hasHeaderRow: false)
//            var transposedCSV = reader1.map({$0}).transposed()
//            let dates = transposedCSV[0].dropFirst().map(Date.convertFromStr)
//
//            let reader2 = try CSVReader(string: String(data: dailyConfirmedCases, encoding: .utf8)!, hasHeaderRow: false)
//            transposedCSV = reader2.map({$0}).transposed()
//            var reducedArr = Array(transposedCSV[2..<transposedCSV.count])
//            let prefectures = reducedArr.map(convertToPrefecture)
//
//            let reader3 = try CSVReader(string: String(data: dailyConfirmedCases, encoding: .utf8)!, hasHeaderRow: false)
//            transposedCSV = reader3.map({$0}).transposed()
//            reducedArr = Array(transposedCSV[2..<transposedCSV.count])
//            let newConfirmedCases = createStatistic(dates, reducedArr)
//
//        } catch {
//            print(error)
//        }
//    }
//
//    func generatePrefectures(_ dates: [Date], _ dailynewCases: [[IndexingIterator<Array<String>>.Element]]) -> [Country] {
//        var prefectures = [Country]()
//
//        return prefectures
//    }
//
//    func convertToPrefecture(_ raw: [String]) -> Country {
//        let prefecture = Country()
//        prefecture.province_state = raw.first!
//        prefecture.name = "Japan"
//        prefecture.regionType = .province_state
//        prefecture.coordinate = RegionCode.prefectures[raw.first!]!
//        return prefecture
//    }
//
//    func createStatistic(_ dates: [Date], _ newConfirmed: [[IndexingIterator<Array<String>>.Element]]) -> [String: [Date : Report]]{
//        var result = [String:[Date:Report]]()
//        for raw in newConfirmed {
//            let key = raw[0]
//            var value = [Date:Report]()
//        }
//        print(dates.count)
//        return result
//    }
    
}

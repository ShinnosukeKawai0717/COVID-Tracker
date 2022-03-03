//
//  DataBase.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 12/2/21.
//

import Foundation

class DataBase {
    
    private var countryCovidstats: Array<Dictionary<String, Int>>
    
    init() {
        self.countryCovidstats = Array<Dictionary<String, Int>>()
    }
  
    public func getCountryCovidStats() -> [[String:Int]] {
        return self.countryCovidstats
    }
    
    public func setCountryCovidStats(with dict: [String:Int]) {
        countryCovidstats.append(dict)
    }
    
}

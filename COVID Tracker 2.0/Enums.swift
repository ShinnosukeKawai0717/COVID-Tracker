//
//  Enums.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/6/22.
//

import Foundation

public enum DataFeild: Int {
    case province_state = 0
    case country_region = 1
    case latitude = 2
    case longtitude = 3
    case firstDay = 4
    case confirmed
    case death
}
public enum RegionType {
    case province_state
    case country
}
public enum DateRange {
    case past30
    case past60
    case past90
    case yearAgo
    
    func getDateRange() -> Int{
        switch self {
        case .past30:
            return 30
        case .past60:
            return 60
        case .past90:
            return 90
        case .yearAgo:
            return 365
        }
    }
    func getName() -> String {
        switch self {
        case .past30:
            return "Last 30 days"
        case .past60:
            return "Last 60 days"
        case .past90:
            return "Last 90 days"
        case .yearAgo:
            return "Last 12 months"
        }
    }
}

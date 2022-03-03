//
//  MenuItem.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/14/22.
//

import Foundation

class MenuItem {
    
    let dateRange: DateRange
    
    init(daterange: DateRange) {
        self.dateRange = daterange
    }
    required init() {
        fatalError()
    }
}

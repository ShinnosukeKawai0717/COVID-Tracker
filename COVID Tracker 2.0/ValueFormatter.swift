//
//  ValueFormatter.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/19/22.
//

import Foundation
import Charts

final class ChartYAxisValueFormatter: NSObject, AxisValueFormatter {
    func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String {
        let intValue = Int(value)
        var strValue = String(intValue)
        if String(intValue).count > 3 {
            strValue = "\(String(intValue).dropLast(3))K"
        }
        if String(intValue).count > 6 {
            strValue = "\(String(intValue).dropLast(6))M"
        }
        return strValue
    }
}

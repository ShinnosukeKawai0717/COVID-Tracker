//
//  RegionManager.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/16/22.
//

import Foundation

class RegionManager {
    static let shared = RegionManager()
    func sort(_ regions: [Region], by attribute: DataFeild) -> [Region] {
        guard regions.count > 1 else {
            return regions
        }
        let leftRegions = Array(regions[0..<regions.count / 2])
        let rightRegions = Array(regions[regions.count/2..<regions.count])
        
        return merge(left: sort(leftRegions, by: attribute), right: sort(rightRegions, by: attribute), by: attribute)
    }
    
    private func merge(left: [Region], right: [Region], by feild: DataFeild) -> [Region] {
        var mergedRegions = [Region]()
        var left = left
        var right = right
        
        if feild == .confirmed {
            while !left.isEmpty && !right.isEmpty {
                let leftCases = left.first!.actuals?.cases ?? 0
                let rightCases = right.first!.actuals?.cases ?? 0
                if leftCases > rightCases {
                    mergedRegions.append(left.removeFirst())
                } else {
                    mergedRegions.append(right.removeFirst())
                }
            }
        } else {
            while !left.isEmpty && !right.isEmpty {
                let leftCases = left.first!.actuals?.deaths ?? 0
                let rightCases = right.first!.actuals?.deaths ?? 0
                if leftCases > rightCases {
                    mergedRegions.append(left.removeFirst())
                } else {
                    mergedRegions.append(right.removeFirst())
                }
            }
        }
        
        return mergedRegions + left + right
    }
}

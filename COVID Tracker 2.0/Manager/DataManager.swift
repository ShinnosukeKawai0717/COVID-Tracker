//
//  DataManager.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/30/22.
//

import Foundation
import ProgressHUD
import Algorithm

class DataManager {
    static let shared = DataManager()
    
    public func loadData(completion: @escaping ([Region]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var regions = [Region]()
        
        dispatchGroup.enter()
        JHUService.shared.fetchGlobalData { result in
            regions += result
            dispatchGroup.leave()
            print("Successfuly fetched global data")
        }
        
        dispatchGroup.enter()
        CANGovService.shared.fetchCanadaData { canada in
            regions.append(canada)
            dispatchGroup.leave()
            print("Successfuly fetched canada data")
        }
        
        dispatchGroup.notify(queue: .main) {
            // remove minor regions and sort by total cases
            regions = RegionManager.shared.sort(regions, by: .confirmed).filter(self.removeRegions)
            
            print("Successfuly fetched all the data")
            completion(regions)
        }
    }
    
    func removeRegions(region: Region) -> Bool {
        return region.country_region != "Summer Olympics 2020"
            && region.combined_key != "Unknown, China"
            && region.province_state != "Diamond Princess"
            && region.province_state != "Grand Princess"
            && region.combined_key != "Diamond Princess"
    }
}

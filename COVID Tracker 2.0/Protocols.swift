//
//  Protocols.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/15/22.
//

import Foundation

protocol PopDownMenuViewControllerDelegate: AnyObject {
    func dateRangeSelected(range: Int)
}
protocol RegionListViewControllerDelegate: AnyObject {
    func regionList(regionPicked region: Region)
}

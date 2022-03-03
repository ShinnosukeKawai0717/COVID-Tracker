//
//  SearchViewController.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/3/22.
//

import UIKit
import Disk
import CoreLocation
import MapKit

class COVIDDataViewController: UIViewController {
    
    private let covidStatsTableView: UITableView = {
        let table = UITableView()
        table.register(BarChartTableViewCell.self, forCellReuseIdentifier: BarChartTableViewCell.idetifier)
        table.register(LineChartTableViewCell.self, forCellReuseIdentifier: LineChartTableViewCell.idetifier)
        table.register(TopThreeChartTableViewCell.self, forCellReuseIdentifier: TopThreeChartTableViewCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isHidden = false
        return table
    }()
    private let statsHeader : StatsHeaderView = {
        let header = StatsHeaderView()
        return header
    }()
    private let topHeaderView: TopHeaderView = {
       let header = TopHeaderView()
        return header
    }()
    private let popDownMenuView = PopDownMenuViewController()
    public var region = Region() {
        didSet {
            modifyTimeseries()
        }
    }
    private var dateRange = 30 {
        didSet {
            modifyTimeseries()
        }
    }
    private var topThreeRegions = [Region]() {
        didSet {
            DispatchQueue.main.async {
                self.covidStatsTableView.reloadData()
            }
        }
    }
    private var timeseries = [Timeseries]() {
        didSet {
            DispatchQueue.main.async {
                self.covidStatsTableView.reloadData()
            }
        }
    }
    public func getTopHeader() -> TopHeaderView {
        return self.topHeaderView
    }
    public func getCovidStatsTable() -> UITableView {
        return self.covidStatsTableView
    }
    public func getStatsHeader() -> StatsHeaderView {
        return self.statsHeader
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        covidStatsTableView.dataSource = self
        covidStatsTableView.delegate = self
        popDownMenuView.popDownMenuDelegate = self
        RegionListViewController.sharedInstance.regionListDelegate = self
        topHeaderView.addTargetForMenuButton(target: self, selector: #selector(menuButtonPressed), for: .touchUpInside)
        topHeaderView.addTargetForSearchButton(target: self, action: #selector(searchTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(didRegionLoaded), name: Notification.Name(rawValue: "regions"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRegion), name: Notification.Name("region for stats header"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMyRegion), name: Notification.Name("my region"), object: nil)
    }
    @objc func didReceiveRegion(_ notification: Notification) {
        let selectedRegion = notification.object as! Region
        self.statsHeader.configureDataLabels(with: selectedRegion)
        self.topHeaderView.configureTitle(with: selectedRegion)
    }
    @objc func didRegionLoaded(_ notification: Notification) {
        let regions = notification.object as! [Region]
        topThreeRegions = Array(regions[0..<3])
        RegionListViewController.sharedInstance.retrieveRegions(regions)
    }
    @objc func didReceiveMyRegion(_ notification: Notification) {
        let myRegion = notification.object as! Region
        self.region = myRegion
    }
    @objc func menuButtonPressed() {
        popDownMenuView.popover(at: topHeaderView.getMenuButton())
        self.present(popDownMenuView, animated: true, completion: nil)
    }
    
    @objc func searchTapped() {
        let regionVC = RegionListViewController.sharedInstance
        present(regionVC, animated: true){
            regionVC.showKeyBoard()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(topHeaderView)
        view.addSubview(covidStatsTableView)
        addTableHeader()
        addConstraintsTopHeader()
        addConstraintsToCovidStats()
    }
    
    private func modifyTimeseries() {
        let timeseries = region.actualsTimeseries
        let totalIndices = timeseries.count - 1
        var dataSet = [Timeseries]()
        for index in 0..<dateRange {
            dataSet.append(timeseries[totalIndices - index])
        }
        self.timeseries = dataSet
    }
    
    private func addTableHeader() {
        statsHeader.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height / 8)
        covidStatsTableView.tableHeaderView = statsHeader
    }
    
    private func addConstraintsTopHeader() {
        NSLayoutConstraint.activate([
            topHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            topHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topHeaderView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func addConstraintsToCovidStats() {
        var constrains = [NSLayoutConstraint]()
        constrains.append(covidStatsTableView.topAnchor.constraint(equalTo: topHeaderView.bottomAnchor))
        constrains.append(covidStatsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constrains.append(covidStatsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constrains.append(covidStatsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constrains)
    }
}

extension COVIDDataViewController: PopDownMenuViewControllerDelegate, RegionListViewControllerDelegate {
    func dateRangeSelected(range: Int) {
        self.dateRange = range
    }
    func regionList(regionPicked region: Region) {
        self.region = region
    }
}

extension COVIDDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let combineCell = tableView.dequeueReusableCell(withIdentifier: TopThreeChartTableViewCell.reuseIdentifier, for: indexPath) as! TopThreeChartTableViewCell
            if !topThreeRegions.isEmpty {
                combineCell.configure(topThreeRegions)
                return combineCell
            }
            return combineCell
        }
        else if indexPath.row == 1 {
            let barCell = tableView.dequeueReusableCell(withIdentifier: BarChartTableViewCell.idetifier, for: indexPath) as! BarChartTableViewCell
            barCell.configureBarChart(timeseries)
            return barCell
        }
        let lineCell = tableView.dequeueReusableCell(withIdentifier: LineChartTableViewCell.idetifier, for: indexPath) as! LineChartTableViewCell
        lineCell.configuureLineChart(timeseries)
        return lineCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 400
        }
        return 400
    }
}

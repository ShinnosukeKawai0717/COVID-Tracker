//
//  HistoricalTableViewCell.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/4/22.
//

import UIKit
import Charts

class BarChartTableViewCell: UITableViewCell {
    static let idetifier = "BarChartTableViewCell"
    private let historicalChartView: BarChartView = {
        let chart = BarChartView()
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.valueFormatter = ChartYAxisValueFormatter()
        chart.animate(xAxisDuration: 2.0)
        chart.animate(yAxisDuration: 2.0)
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public func configureBarChart(_ timeseries: [Timeseries]) {
        var dataEntries = [BarChartDataEntry]()

        for (x, y) in timeseries.reversed().enumerated() {
            if let cases = y.newCases {
                let entry = BarChartDataEntry(x: Double(x), y: Double(cases))
                dataEntries.append(entry)
            }
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "New cases")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.drawValuesEnabled = false
        
        self.historicalChartView.data = BarChartData(dataSet: dataSet)
        DispatchQueue.main.async {
            self.historicalChartView.animate(xAxisDuration: 2.0)
            self.historicalChartView.animate(yAxisDuration: 2.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(historicalChartView)
        NSLayoutConstraint.activate([
            historicalChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            historicalChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            historicalChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            historicalChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

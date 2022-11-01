//
//  LineChartTableViewCell.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/4/22.
//

import UIKit
import Charts

class LineChartTableViewCell: UITableViewCell {
    
    static let idetifier = "LineChartTableViewCell"
    private let lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.animate(xAxisDuration: 3.0)
        chart.animate(yAxisDuration: 3.0)
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.valueFormatter = ChartYAxisValueFormatter()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private lazy var lineChartDataSet: LineChartDataSet = {
        let dataSet = LineChartDataSet(label: "Daily deaths")
        dataSet.fill = LinearGradientFill(gradient: gradient!) // Set the Gradient
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true // Draw the Gradient
        dataSet.mode = .linear
        dataSet.lineWidth = 1
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.setColor(.systemRed)
        return dataSet
    }()
    
    // Gradient Object
    let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.clear.cgColor, UIColor.systemRed.cgColor] as CFArray, locations: nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public func configuureLineChart(_ timeseries: [Timeseries]) {
        var dataEntries = [ChartDataEntry]()
        
        for (x, y) in timeseries.reversed().enumerated() {
            if let dailyDeaths = y.newDeaths {
                let entry = ChartDataEntry(x: Double(x), y: Double(dailyDeaths))
                dataEntries.append(entry)
            }
        }
        
        self.lineChartDataSet.replaceEntries(dataEntries)
        let data = LineChartData(dataSet: lineChartDataSet)
        self.lineChartView.data = data
        
        DispatchQueue.main.async {
            self.lineChartView.animate(xAxisDuration: 2.0)
            self.lineChartView.animate(yAxisDuration: 2.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(lineChartView)
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

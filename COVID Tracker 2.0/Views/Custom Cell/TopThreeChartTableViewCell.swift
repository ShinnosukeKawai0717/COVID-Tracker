//
//  CombineChartViewCell.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/15/22.
//

import UIKit
import Charts

class TopThreeChartTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TopThreeChartTableViewCell"
    private let topThreeChartView: LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.drawGridLinesBehindDataEnabled = true
        view.leftAxis.valueFormatter = ChartYAxisValueFormatter()
        view.legend.enabled = true
        view.leftAxis.labelPosition = .insideChart
        view.leftAxis.setLabelCount(4, force: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var firstDataSet: LineChartDataSet = {
        let dataSet = LineChartDataSet()
        dataSet.setColor(.systemRed)
        dataSet.lineWidth = 2.3
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        return dataSet
    }()
    private var secondDataSet: LineChartDataSet = {
        let dataSet = LineChartDataSet()
        dataSet.setColor(.systemBlue)
        dataSet.lineWidth = 2.3
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        return dataSet
    }()
    private var thirdDataSet: LineChartDataSet = {
        let dataSet = LineChartDataSet()
        dataSet.setColor(.systemGreen)
        dataSet.lineWidth = 2.3
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        return dataSet
    }()
    
    let firstLegend = LegendEntry(label: "", form: .circle, formSize: 12, formLineWidth: 2, formLineDashPhase: 2, formLineDashLengths: nil, formColor: .systemRed)
    let secondLegend = LegendEntry(label: "", form: .circle, formSize: 12, formLineWidth: 2, formLineDashPhase: 2, formLineDashLengths: nil, formColor: .systemBlue)
    let thirdLegend = LegendEntry(label: "", form: .circle, formSize: 12, formLineWidth: 2, formLineDashPhase: 2, formLineDashLengths: nil, formColor: .systemGreen)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        topThreeChartView.delegate = self
    }
    
    func configure(_ topThree: [Region]) {
        let firstRegion = topThree[0].actualsTimeseries
        let secondRegion = topThree[1].actualsTimeseries
        let thirdRegion = topThree[2].actualsTimeseries
        
        firstLegend.label = topThree[0].combined_key
        secondLegend.label = topThree[1].combined_key
        thirdLegend.label = topThree[2].combined_key
        let legends = [firstLegend, secondLegend, thirdLegend]
        
        var firstEntries = [ChartDataEntry]()
        var secondEntries = [ChartDataEntry]()
        var thirdEntries = [ChartDataEntry]()
        
        for (x, y) in firstRegion.enumerated() {
            if let totalCases = y.cases {
                let entry = ChartDataEntry(x: Double(x), y: Double(totalCases))
                firstEntries.append(entry)
            }
        }
        for (x, y) in secondRegion.enumerated() {
            if let totalCases = y.cases {
                let entry = ChartDataEntry(x: Double(x), y: Double(totalCases))
                secondEntries.append(entry)
            }
        }
        for (x, y) in thirdRegion.enumerated() {
            if let totalCases = y.cases {
                let entry = ChartDataEntry(x: Double(x), y: Double(totalCases))
                thirdEntries.append(entry)
            }
        }
        
        firstDataSet.replaceEntries(firstEntries)
        secondDataSet.replaceEntries(secondEntries)
        thirdDataSet.replaceEntries(thirdEntries)
        
        let data = LineChartData(dataSets: [firstDataSet, secondDataSet, thirdDataSet])
        
        DispatchQueue.main.async {
            self.topThreeChartView.data = data
            self.topThreeChartView.legend.entries = legends
            self.topThreeChartView.animate(xAxisDuration: 2.0)
        }
    }
    func setTimeSeries(_ timeseries: [[Timeseries]]) {
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(topThreeChartView)
        NSLayoutConstraint.activate([
            topThreeChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topThreeChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topThreeChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topThreeChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TopThreeChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
}

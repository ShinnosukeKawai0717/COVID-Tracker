//
//  CountryTableViewCell.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/4/22.
//

import UIKit
import Charts

class CountryListTableViewCell: UITableViewCell {
    static let idetifier = "CountryListTableViewCell"
    
    private let labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalNumLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let caseDiffLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemOrange
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.rightAxis.drawBottomYLabelEntryEnabled = false
        chart.rightAxis.drawTopYLabelEntryEnabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.drawBottomYLabelEntryEnabled = false
        chart.leftAxis.drawTopYLabelEntryEnabled = false
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    private lazy var chartDataSet: LineChartDataSet = {
        let dataSet = LineChartDataSet(label: "")
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90)
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true
        dataSet.mode = .linear
        dataSet.lineWidth = 2
        dataSet.setColor(.systemRed)
        dataSet.form = .none
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        return dataSet
    }()
    
    // Gradient Object
    let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.clear.cgColor, UIColor.systemRed.cgColor] as CFArray, locations: nil)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineChartView)
        contentView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(totalNumLabel)
        labelStackView.addArrangedSubview(caseDiffLabel)
    }
    
    public func configure(with model: Region) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.combined_key
            self.totalNumLabel.text = String(model.actuals?.cases ?? 0)
            self.caseDiffLabel.text = "+\(String(model.actuals?.newCases ?? 0))"
        }
        
        let timeseries = model.actualsTimeseries
        var reducedseries = [Timeseries]()
        let totalIndices = timeseries.count - 1
        
        for index in 0..<30 {
            reducedseries.append(timeseries[totalIndices - index])
        }
        configureChart(reducedseries)
    }
    
    private func configureChart(_ timeseries: [Timeseries]) {
        var dataEntries = [ChartDataEntry]()
        
        for (x, y) in timeseries.reversed().enumerated() {
            if let cumulative = y.newCases {
                let entry = ChartDataEntry(x: Double(x), y: Double(cumulative))
                dataEntries.append(entry)
            }
        }
        
        self.chartDataSet.replaceEntries(dataEntries)
        let data = LineChartData(dataSet: chartDataSet)
        DispatchQueue.main.async {
            self.lineChartView.data = data
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CountryListTableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        // add constraint to title label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // add constraint to stack view
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelStackView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // add constarain to line chart view
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            lineChartView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 5)
        ])
    }
}

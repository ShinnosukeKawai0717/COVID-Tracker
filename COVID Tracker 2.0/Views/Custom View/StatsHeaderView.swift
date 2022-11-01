//
//  StatsHeaderView.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/6/22.
//

import Foundation
import UIKit

class StatsHeaderView: UIView {
    
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let caseStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let caseNumStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recoverStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recoverNumStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deathStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deathNumStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let caseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Comfirmed"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let deathLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Death"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let recoverLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.text = "Recovered"
        return label
    }()
    
    private let caseNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .systemOrange
        return label
    }()
    
    private let deathNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .systemRed
        return label
    }()
    
    private let recoverNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .systemGreen
        return label
    }()
    
    private let caseDiffLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemOrange
        return label
    }()
    
    private let deathDiffLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemRed
        return label
    }()
    
    private let recoverDiffLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        return label
    }()
    private let animater = UIView()
    
    init() {
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initMainView()
    }
    
    public func configureDataLabels(with model: Region) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.caseNumLabel.fadeTransition()
            self.deathNumLabel.fadeTransition()
            self.caseDiffLabel.fadeTransition()
            self.deathDiffLabel.fadeTransition()
            self.caseNumLabel.text = String(model.actuals?.cases ?? 0)
            self.caseDiffLabel.text = "+\(String(model.actuals?.newCases ?? 0))"
            self.deathNumLabel.text = String(model.actuals?.deaths ?? 0)
            self.deathDiffLabel.text = "+\(String(model.actuals?.newDeaths ?? 0))"
        }
    }
    
    private func initMainView() {
        setUpMainStack()
        setUpCaseStack()
        setUpRecoverStack()
        setUpDeathStack()
    }
    
    private func setUpMainStack() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(caseStackView)
        mainStackView.addArrangedSubview(recoverStackView)
        mainStackView.addArrangedSubview(deathStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCaseStack() {
        // add constraints to caseStackView
        NSLayoutConstraint.activate([
            caseStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            caseStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
        ])
        
        caseStackView.addArrangedSubview(caseNumStackView)
        // add constraints to caseNumStackView
        NSLayoutConstraint.activate([
            caseNumStackView.topAnchor.constraint(equalTo: caseStackView.topAnchor),
            caseNumStackView.bottomAnchor.constraint(equalTo: caseStackView.bottomAnchor)
        ])
        caseNumStackView.addArrangedSubview(caseLabel)
        caseNumStackView.addArrangedSubview(caseNumLabel)
        caseNumStackView.addArrangedSubview(caseDiffLabel)
    }
    
    private func setUpRecoverStack() {
        //add constraints to recoverStackView
        NSLayoutConstraint.activate([
            recoverStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            recoverStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
        recoverStackView.addArrangedSubview(recoverNumStackView)
        
        // add constraints to recoverNumStackView
        NSLayoutConstraint.activate([
            recoverNumStackView.topAnchor.constraint(equalTo: recoverStackView.topAnchor),
            recoverNumStackView.bottomAnchor.constraint(equalTo: recoverStackView.bottomAnchor)
        ])
        recoverNumStackView.addArrangedSubview(recoverLabel)
        recoverNumStackView.addArrangedSubview(recoverNumLabel)
        recoverNumStackView.addArrangedSubview(recoverDiffLabel)
    }
    
    private func setUpDeathStack() {
        //add constraints to deathStackView
        NSLayoutConstraint.activate([
            deathStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            deathStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
        deathStackView.addArrangedSubview(deathNumStackView)
        
        // add constraints to deathNumStackView
        NSLayoutConstraint.activate([
            deathNumStackView.topAnchor.constraint(equalTo: deathStackView.topAnchor),
            deathNumStackView.bottomAnchor.constraint(equalTo: deathStackView.bottomAnchor)
        ])
        deathNumStackView.addArrangedSubview(deathLabel)
        deathNumStackView.addArrangedSubview(deathNumLabel)
        deathNumStackView.addArrangedSubview(deathDiffLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

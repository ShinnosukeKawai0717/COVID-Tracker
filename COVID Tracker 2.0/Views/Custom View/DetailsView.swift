//
//  DetailView.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 12/4/21.
//

import Foundation
import UIKit

class DetailsView: UIView {
    
    private var confirmed: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Confirmed:"
        label.textAlignment = .right
        label.textColor = .systemOrange
        return label
    }()
    
    private var confirmedNum: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .systemOrange
        return label
    }()
    
    private var death: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Death:"
        label.textColor = .systemRed
        return label
    }()
    
    private var deathNum: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .systemRed
        return label
    }()
    
    private var recovered: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Recovered:"
        label.textColor = .systemGreen
        return label
    }()
    
    private var recoveredNum: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .systemGreen
        return label
    }()
    
    private var active: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Active:"
        label.textColor = .systemYellow
        return label
    }()
    
    private var activeNum: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .systemYellow
        return label
    }()
    
    private var mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var confirmedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var recoveredStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var deathStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var activeStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(model: Region){
        super.init(frame: .zero)
        initMainView()
        if let totalCase = model.actuals?.cases, let totalDeaths = model.actuals?.deaths {
            DispatchQueue.main.async {
                self.confirmedNum.text = String(totalCase)
                self.deathNum.text = String(totalDeaths)
                self.recoveredNum.text = "-"
                self.activeNum.text = "-"
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureMainStack()
        setUpConfirmedStack()
        setUpRecoveredStack()
        configureActiveStack()
        configureDeathStack()
    }
    
    func initMainView() {
        self.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func configureMainStack() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        mainStackView.addArrangedSubview(confirmedStackView)
        mainStackView.addArrangedSubview(recoveredStackView)
        mainStackView.addArrangedSubview(activeStackView)
        mainStackView.addArrangedSubview(deathStackView)
    }
    
    func setUpConfirmedStack() {
        confirmedStackView.addArrangedSubview(confirmed)
        confirmedStackView.addArrangedSubview(confirmedNum)
        NSLayoutConstraint.activate([
            confirmedStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            confirmedStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    func setUpRecoveredStack() {
        recoveredStackView.addArrangedSubview(recovered)
        recoveredStackView.addArrangedSubview(recoveredNum)
        NSLayoutConstraint.activate([
            recoveredStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            recoveredStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    func configureDeathStack() {
        deathStackView.addArrangedSubview(death)
        deathStackView.addArrangedSubview(deathNum)
        NSLayoutConstraint.activate([
            deathStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            deathStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor)
        ])
    }
    
    func configureActiveStack() {
        activeStackView.addArrangedSubview(active)
        activeStackView.addArrangedSubview(activeNum)
        NSLayoutConstraint.activate([
            activeStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            activeStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error...")
    }
    
}

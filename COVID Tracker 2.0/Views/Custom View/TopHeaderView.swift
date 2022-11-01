//
//  PanelHeaderView.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/3/22.
//

import Foundation
import UIKit

class TopHeaderView: UIView {
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.tintColor = .systemGray
        return button
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.tintColor = .systemGray
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 0
        label.textColor = .systemGreen
        label.textAlignment = .left
        label.isHidden = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initMainView()
        addConstraintSearchButton()
        addConstraintTitleLabel()
        addConstraintMenuButton()
    }
    public func getMenuButton() -> UIButton {
        return self.menuButton
    }
    public func addTargetForSearchButton(target: Any?, action: Selector, for event: UIControl.Event) {
        self.searchButton.addTarget(target, action: action, for: event)
    }
    public func addTargetForMenuButton(target: Any?, selector: Selector, for event: UIControl.Event) {
        self.menuButton.addTarget(target, action: selector, for: event)
    }
    public func configureTitle(with model: Region) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.titleLabel.fadeTransition(0.6)
            self.titleLabel.text =  model.combined_key
        }
    }
    public func configureTitle(with title: String) {
        DispatchQueue.main.async {
            self.titleLabel.animate {
                self.titleLabel.text = title
            }
        }
    }
    private func initMainView() {
        addSubview(searchButton)
        addSubview(titleLabel)
        addSubview(menuButton)
    }
    private func addConstraintSearchButton() {
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -20),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func addConstraintMenuButton() {
        NSLayoutConstraint.activate([
            menuButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            menuButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    private func addConstraintTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("Error...")
    }
}

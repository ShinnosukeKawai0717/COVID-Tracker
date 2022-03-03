//
//  PopUpViewController.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 1/10/22.
//

import UIKit

class PopDownMenuViewController: UIViewController {
    
    private let itemTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        return table
    }()
    
    let items = [MenuItem(daterange: .past30), MenuItem(daterange: .past60), MenuItem(daterange: .past90), MenuItem(daterange: .yearAgo)]
    weak var popDownMenuDelegate: PopDownMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
        itemTableView.delegate = self
        view.addSubview(itemTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = CGSize(width: 200, height: itemTableView.contentSize.height)
        itemTableView.frame = view.bounds
    }
}

extension PopDownMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = items[indexPath.row].dateRange.getName()
            cell.contentConfiguration = content
        }
        else {
            cell.textLabel?.text = items[indexPath.row].dateRange.getName()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = tableView.cellForRow(at: indexPath) {
            item.accessoryType = .checkmark
            item.isSelected = false
        }
        let dateRange = items[indexPath.row].dateRange.getDateRange()
        
        popDownMenuDelegate?.dateRangeSelected(range: dateRange)
        
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let item = tableView.cellForRow(at: indexPath) {
            item.accessoryType = .none
        }
    }
}

extension PopDownMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popover(at sender: AnyObject?) {
        self.modalPresentationStyle = .popover
            
        if let popover = self.popoverPresentationController {
            popover.permittedArrowDirections = .up
            if let view = sender as? UIView {
                popover.sourceView = view
                popover.sourceRect = view.bounds
            }
            popover.delegate = self
        }
    }
}

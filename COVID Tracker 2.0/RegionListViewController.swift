//
//  RegionListViewController.swift
//  COVID Tracker 2.0
//
//  Created by Shinnosuke Kawai on 2/14/22.
//

import UIKit

protocol RegionListViewControllerDelegate: AnyObject {
    func regionListViewController(_ vc: RegionListViewController, didPick region: Region)
}

class RegionListViewController: UIViewController {
    private let regionListTableView: UITableView = {
        let table = UITableView()
        table.register(CountryListTableViewCell.self, forCellReuseIdentifier: CountryListTableViewCell.idetifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    private let regionSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search here"
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.searchTextField.font = .boldSystemFont(ofSize: 15)
        return bar
    }()
    private var filteredRegions = [Region]()
    private var regions = [Region]() {
        didSet {
            self.filteredRegions = regions
            DispatchQueue.main.async {
                self.regionListTableView.reloadData()
            }
        }
    }
    weak var delegate: RegionListViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.regionListTableView.delegate = self
        self.regionListTableView.dataSource  = self
        self.regionSearchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(regionListTableView)
        view.addSubview(regionSearchBar)
        layoutSearchBar()
        layoutTableView()
    }
    
    public func setRegions(_ regions: [Region]) {
        self.regions = regions
    }
    public func showKeyBoard() {
        self.regionSearchBar.becomeFirstResponder()
    }
    private func layoutSearchBar() {
        NSLayoutConstraint.activate([
            regionSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            regionSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regionSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            regionSearchBar.heightAnchor.constraint(equalToConstant: view.frame.height / 12)
        ])
    }
    private func layoutTableView() {
        NSLayoutConstraint.activate([
            regionListTableView.topAnchor.constraint(equalTo: regionSearchBar.bottomAnchor),
            regionListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            regionListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            regionListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RegionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredRegions.isEmpty {
            return filteredRegions.count
        }
        return regions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryListTableViewCell.idetifier, for: indexPath) as! CountryListTableViewCell
        if !filteredRegions.isEmpty {
            cell.configure(with: self.filteredRegions[indexPath.row])
        }
        else {
            cell.configure(with: self.regions[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCountry = filteredRegions[indexPath.row]
        if let selectionDelegate = delegate {
            selectionDelegate.regionListViewController(self, didPick: selectedCountry)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "region for map center"), object: selectedCountry.coordinate)
        }
        regionSearchBar.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegionListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRegions = []
        if searchText == "" {
            filteredRegions = regions
        }
        else {
            filteredRegions = regions.filter({ nation in
                return nation.combined_key.lowercased().contains(searchText.lowercased())
            })
        }
        DispatchQueue.main.async {
            self.regionListTableView.reloadData()
        }
    }
}

//
//  ViewController.swift
//  SearchApp
//
//  Created by Денис Андриевский on 22.07.2020.
//  Copyright © 2020 Денис Андриевский. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Instances
    private var searchResults: Result = []
    private var searchController: UISearchController?
    private let requestManager = RequestManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: C.cellidentifier)
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.backgroundImage = UIImage()
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    // MARK: - Update Results
    private func updateResults(text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.requestManager.cancelTask()
            self.requestDataFor(text)
        }
    }
    
    // MARK: - Search Request
    private func requestDataFor(_ text: String) {
        requestManager.requestForQuery(text) { [unowned self] (data, _, error) in
            guard error == nil, let data = data, let parsedData = try? JSONDecoder().decode(Result.self, from: data) else { return }
            self.searchResults = parsedData
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    // MARK: - Update UI
    private func updateUI() {
        self.tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate, UISearchResultsUpdating
extension MainVC: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchInput = searchController.searchBar.text else { return }
        if searchInput.isEmpty {
            searchResults = []
            updateUI()
        } else {
            updateResults(text: searchInput.lowercased())
        }
    }
    
}

// MARK: - UITableViewDelegate
extension MainVC: UITableViewDelegate { }

// MARK: - UITableViewDataSource
extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellidentifier, for: indexPath)
        cell.textLabel?.text = "\(searchResults[indexPath.row][0].value()) - \(searchResults[indexPath.row][1].value())"
        return cell
    }
    
}

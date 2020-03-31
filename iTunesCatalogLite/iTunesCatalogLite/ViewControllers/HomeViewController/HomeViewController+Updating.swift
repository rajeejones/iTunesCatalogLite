//
//  HomeViewController+Updating.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // prepare results

        guard let searchString = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            searchString.count >= 3 else {
                return
        }

        guard let searchRequest = iTunesSearchRequest(term: searchString, media: searchScopes[selectedScopeIndex]) else {
            return
        }

        iTunesCatalogLiteManager.shared.searchCatalog(searchRequest) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.handleSearchResults(searchResults)
                }
            case .failure(let error):
                // TODO: Handle errors
                DispatchQueue.main.async {
                    self.handleSearchResults([])
                }
            }
        }
    }

    fileprivate func handleSearchResults(_ results: [iTunesSearchResult]) {
        // sort based on the media type
        let sortedResults = results.sorted { (firstItem, secondItem) -> Bool in
            firstItem.type.rawValue > secondItem.type.rawValue
        }

        if let resultsController = searchController.searchResultsController as? ResultsTableViewController {
            resultsController.results = sortedResults
            resultsController.tableView.reloadData()
            resultsController.resultsLabel?.text = resultsController.results.isEmpty ? "No results" : String(format: "Found %d results:", resultsController.results.count)
        }
    }

}



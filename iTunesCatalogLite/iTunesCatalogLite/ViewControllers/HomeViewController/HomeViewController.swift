//
//  HomeViewController.swift
//  iTunesCatalogLite
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

class HomeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var containerCollectionView: UICollectionView!

    // MARK: - Properties

    var searchController: UISearchController = UISearchController()
    var resultsTableViewController: ResultsTableViewController = ResultsTableViewController()
    //var restoredState = SearchControllerRestorableState()

    var searchScopes: [iTunesSearchRequest.SearchMedia] = [
        iTunesSearchRequest.SearchMedia.all,
        iTunesSearchRequest.SearchMedia.music,
        iTunesSearchRequest.SearchMedia.movie,
        iTunesSearchRequest.SearchMedia.tvShow,
        iTunesSearchRequest.SearchMedia.podcast,
    ]
    var selectedScopeIndex: Int = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    func setupViews() {
        configureLargeTitles()
        configureSearchController()

        configureFavoritesCollectionView()
    }

    func configureSearchController() {
        guard let catalogResultsVC = storyboard?.instantiateViewController(identifier: ResultsTableViewController.storyboardID) as? ResultsTableViewController else {
            fatalError("Could not create table view controller")
        }

        resultsTableViewController = catalogResultsVC
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = searchScopes.compactMap({ $0.title })

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        definesPresentationContext = true
    }
}

// MARK: - View Helpers
extension HomeViewController {

    func configureLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureFavoritesCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        containerCollectionView.collectionViewLayout = flowLayout

        containerCollectionView.delegate = self
        containerCollectionView.dataSource = self

        let favoriteCellNib = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        containerCollectionView.register(favoriteCellNib, forCellWithReuseIdentifier: FavoriteCollectionViewCell.cellId)
    }
}

// MARK: - UISearchBarDelegate & UISearchControllerDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedScopeIndex = selectedScope
    }
}

// MARK: - Favorites Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {

}

// MARK: - Favorites Collection View DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.cellId, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.itemNameLabel?.text = nil
        cell.backgroundColor = .clear
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 175)
    }
}

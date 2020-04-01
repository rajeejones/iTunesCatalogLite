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

    @IBOutlet weak var favoritesCollectionView: UICollectionView!

    // MARK: - Properties

    var searchController: UISearchController = UISearchController()
    var resultsTableViewController: ResultsTableViewController = ResultsTableViewController()
    //var restoredState = SearchControllerRestorableState()
    var favorites: [iTunesSearchResult] = []
    var selectedItem: iTunesSearchResult? = nil

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        StorageManager.loadFavorites { [weak self] (results) in
            guard let self = self,
                let items = results else {
                return
            }

            DispatchQueue.main.async {
                self.favorites = items
                self.favoritesCollectionView.reloadData()
            }

        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            guard let detailViewController = segue.destination as? DetailViewController else {
                return
            }

            detailViewController.result = selectedItem
        }
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
        favoritesCollectionView.collectionViewLayout = flowLayout

        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self

        let favoriteCellNib = UINib(nibName: "FavoriteCollectionViewCell", bundle: nil)
        favoritesCollectionView.register(favoriteCellNib, forCellWithReuseIdentifier: FavoriteCollectionViewCell.cellId)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItem = favorites[indexPath.row]

        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
}

// MARK: - Favorites Collection View DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.cellId, for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(favorites[indexPath.row])
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 175)
    }
}

//
//  ContentView.swift
//  iTunesCatalogTV
//
//  Created by Rajee Jones on 4/10/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import SwiftUI
import TVUIKit
import iTunesCatalogLite_API

// MARK: - Helper to configure a standard UITableViewCell
extension UITableViewCell {
    func configureCell(withResult result: iTunesSearchResult, indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.textLabel?.text = result.name
            self.detailTextLabel?.text = result.genre
        }
    }
}

// MARK: - Protocol to update detail of the splitView controller
protocol ResultsTableViewController_TVDelegate: class {
    func didReceiveResults(_ results: ([iTunesResultType : [iTunesSearchResult]]))
}

// MARK: - TableViewController for the text results on the left of the results
class ResultsTableViewController_TV: UITableViewController {
    var reuseId = "cellId"
    var searchScopes: [iTunesSearchRequest.SearchMedia] = [
        iTunesSearchRequest.SearchMedia.all,
        iTunesSearchRequest.SearchMedia.music,
        iTunesSearchRequest.SearchMedia.movie,
        iTunesSearchRequest.SearchMedia.tvShow,
        iTunesSearchRequest.SearchMedia.podcast,
    ]
    var searchResult = [iTunesResultType : [iTunesSearchResult]]()
    var selectedScopeIndex: Int = 0
    weak var delegate: ResultsTableViewController_TVDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchResult.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the current section based on the index of the dictionary
        let sectionKey = searchResult.keys.compactMap({ $0 })[section]
        guard let resultsForSection = searchResult[sectionKey] else {
            return 0
        }
        return resultsForSection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let sectionKey = searchResult.keys.compactMap({ $0 })[indexPath.section]
        guard let resultsForSection = searchResult[sectionKey] else {
            return UITableViewCell()
        }

        let result = resultsForSection[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseId)
        cell.configureCell(withResult: result, indexPath: indexPath)

        return cell
    }

}
// MARK: - Handles search results from the search controller
extension ResultsTableViewController_TV: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
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
            case .success(let data):
                self.decodeData(data)
            case .failure:
                // TODO: Handle errors
                break
            }
        }
    }

    fileprivate func decodeData(_ data: (Data)) {
        iTunesCatalogLiteManager.shared.decodeSearchResponse(from: data) { [weak self] (result) in
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self?.handleSearchResults(searchResults)
                }
            case .failure:
                // TODO: Handle errors
                break
            }
        }
    }

    fileprivate func handleSearchResults(_ results: ([iTunesResultType : [iTunesSearchResult]])) {
        DispatchQueue.main.async {
            self.searchResult = results
            self.tableView.reloadData()
            self.delegate?.didReceiveResults(results)
        }
    }
}


// MARK: - SplitViewController as the base of the search results
class ResultsSplitViewController: UISplitViewController {
    var resultsTableViewController = ResultsTableViewController_TV()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllers = [
            resultsTableViewController,
            UIViewController()
        ]

        resultsTableViewController.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultsSplitViewController: ResultsTableViewController_TVDelegate {
    func didReceiveResults(_ results: ([iTunesResultType : [iTunesSearchResult]])) {
        // TODO: Update detail view controller image with selection of the tableview cell row
        print(results)
    }
}


// MARK: - Custom SwiftUI Search View with a UISearchController
struct SearchView: UIViewControllerRepresentable {

    func makeUIViewController(context: UIViewControllerRepresentableContext<SearchView>) -> UINavigationController {
        let controller = UISearchController(searchResultsController: context.coordinator)
        controller.searchResultsUpdater = context.coordinator.resultsTableViewController
        return UINavigationController(rootViewController: UISearchContainerViewController(searchController: controller))
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<SearchView>) {
    }

    func makeCoordinator() -> ResultsSplitViewController {
        // MARK: - Return custom results controller
        ResultsSplitViewController()
    }

    // MARK: - base is a UINavigation controller to push detail view when cell is pressed
    typealias UIViewControllerType = UINavigationController
}

// MARK: - SwiftUI Content View
struct ContentView: View {
    @State private var selection = 1
    @State private var text: String = ""
    var body: some View {
        TabView(selection: $selection){
            List {
                Text("Favorites")
                    .font(.headline)
            }
            .tabItem {
                Text("Favorites")
                }
            .tag(0)

            SearchView()
                .tabItem {
                    Text("Search")
            }
            .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

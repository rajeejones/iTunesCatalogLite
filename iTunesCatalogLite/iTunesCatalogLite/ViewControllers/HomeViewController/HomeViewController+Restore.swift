//
//  HomeViewController+Restore.swift
//  iTunesCatalogLite
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//
//  Copyright © 2019 Apple Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
//  (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

// MARK: - Did not implement; pulled from Apple Sample docs

extension HomeViewController {

    /// State restoration values.
    enum RestorationKeys: String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
        case selectedScope
    }

    // State items to be restored in viewDidAppear().
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        // Encode the view state so it can be restored later.

        // Encode the title.
        coder.encode(navigationItem.title!, forKey: RestorationKeys.viewControllerTitle.rawValue)

        // Encode the search controller's active state.
        coder.encode(searchController.isActive, forKey: RestorationKeys.searchControllerIsActive.rawValue)

        // Encode the first responser status.
        coder.encode(searchController.searchBar.isFirstResponder, forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)

        // Encode the first responser status.
        coder.encode(searchController.searchBar.selectedScopeButtonIndex, forKey: RestorationKeys.selectedScope.rawValue)

        // Encode the search bar text.
        coder.encode(searchController.searchBar.text, forKey: RestorationKeys.searchBarText.rawValue)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)

        // Restore the title.
        guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        navigationItem.title! = decodedTitle

        /** Restore the active and first responder state:
            We can't make the searchController active here since it's not part of the view hierarchy yet, instead we do it in viewDidAppear.
        */
        restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
        restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)

        // Restore the scope bar selection.
        searchController.searchBar.selectedScopeButtonIndex = coder.decodeInteger(forKey: RestorationKeys.selectedScope.rawValue)

        // Restore the text in the search field.
        searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
    }
}

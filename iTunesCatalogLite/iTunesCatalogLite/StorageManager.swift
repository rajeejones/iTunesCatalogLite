//
//  StorageManager.swift
//  iTunesCatalogLite
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import Foundation
import iTunesCatalogLite_API

final class StorageManager: NSObject {
    static let favoriteObjectKey = "fav"

    class func favoriteItem(_ item: iTunesSearchResult?,
                            completion: @escaping (_ successful: Bool) -> Void) {
        guard let item = item else {
            completion(false)
            return
        }

        DispatchQueue.global().async {
            let defaults = UserDefaults.standard
            let itemKey = String(item.id)

            if let favorites = (defaults.dictionary(forKey: favoriteObjectKey) as? [String : Data]) {

                var searchFavorites = favorites.compactMapValues({
                    return try? PropertyListDecoder().decode(iTunesSearchResult.self, from: $0)
                })

                // check to see if the item exists; Don't need to save it again
                guard searchFavorites.contains(where: { $0.key == itemKey }) == false else {
                    completion(true)
                    return
                }

                // update favorites to include the new item
                searchFavorites.updateValue(item, forKey: itemKey)

                // convert to [String: Data]
                let newFavorites = searchFavorites.compactMapValues({
                    return try? PropertyListEncoder().encode($0)
                })

                // save
                defaults.set(newFavorites, forKey: favoriteObjectKey)
                completion(true)
            } else {
                // create new favorites dictionary
                if let data = try? PropertyListEncoder().encode(item) {
                    defaults.set([itemKey: data], forKey: favoriteObjectKey)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    class func loadFavorites(completion: @escaping (_ favorites: [iTunesSearchResult]?) -> Void) {
        DispatchQueue.global().async {
            let defaults = UserDefaults.standard
            if let favorites = defaults.dictionary(forKey: favoriteObjectKey) as? [String : Data] {
                let searchResults = favorites.compactMapValues({
                    return try? PropertyListDecoder().decode(iTunesSearchResult.self, from: $0)
                    })
                let items = searchResults.compactMap({ $0.value })
                completion(items)
            }
        }
    }
}

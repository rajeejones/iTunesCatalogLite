//
//  FavoriteCollectionViewCell.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/30/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

class FavoriteCollectionViewCell: UICollectionViewCell {
    public static var cellId = "cellId"

    @IBOutlet weak var itemImageView: UIImageView?
    @IBOutlet weak var itemNameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    func configure(_ favoriteItem: iTunesSearchResult) {
        DispatchQueue.main.async {
            self.itemNameLabel?.text = favoriteItem.name
            
            DispatchQueue.global().async {
                guard let imageUrl = URL(string: favoriteItem.artwork),
                    let imageData = try? Data(contentsOf: imageUrl) else {
                        return
                }

                DispatchQueue.main.async { [weak self] in
                    self?.itemImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }

}

//
//  FavoriteCollectionViewCell.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/30/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    public static var cellId = "cellId"

    @IBOutlet weak var itemImageView: UIImageView?
    @IBOutlet weak var itemNameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

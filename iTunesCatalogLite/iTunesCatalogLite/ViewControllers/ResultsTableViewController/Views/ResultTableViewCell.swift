//
//  ResultTableViewCell.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

class ResultTableViewCell: UITableViewCell {
    static let nibName = "ResultTableViewCell"
    static let reuseId = "ResultTableViewCell.reuse"

    // MARK: - Outlets

    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var itunesButton: UIButton!

    // MARK: - Variables

    var itunesUrl: URL?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        artworkImageView.image = nil
        nameLabel.text = nil
        genreLabel.text = nil
        itunesUrl = nil
    }

    func configure(_ result: iTunesSearchResult) {
        DispatchQueue.main.async {
            self.nameLabel.text = result.name
            self.genreLabel.text = result.genre
            self.itunesUrl = URL(string: result.url)
            self.itunesButton.isEnabled = self.itunesUrl != nil

            DispatchQueue.global().async {
                guard let imageUrl = URL(string: result.artwork),
                    let imageData = try? Data(contentsOf: imageUrl) else {
                        return
                }

                DispatchQueue.main.async { [weak self] in
                    self?.artworkImageView.image = UIImage(data: imageData)
                }
            }
        }
    }

    // MARK: - IBActions
    
    @IBAction func iTunesButtonTapped(_ sender: Any) {
        guard let url = itunesUrl,
            UIApplication.shared.canOpenURL(url) else {
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

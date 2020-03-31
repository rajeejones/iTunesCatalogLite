//
//  DetailViewController.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

class DetailViewController: UIViewController {

    // MARK: - Properties

    static let storyboardId = "DetailViewController"
    var result: iTunesSearchResult?

    // MARK: - Outlets

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.titleLabel.text = self.result?.name
            self.subtitleLabel.text = self.result?.genre

            DispatchQueue.global().async {
                guard let urlString = self.result?.artwork,
                    let imageUrl = URL(string: urlString),
                    let imageData = try? Data(contentsOf: imageUrl) else {
                        return
                }

                DispatchQueue.main.async { [weak self] in
                    self?.artworkImageView.image = UIImage(data: imageData)
                }
            }
        }
    }

    // MARK: - Helpers
    class func viewControllerForResult(_ result: iTunesSearchResult) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: DetailViewController.storyboardId)

        if let detailViewController = viewController as? DetailViewController {
            detailViewController.result = result
        }

        return viewController
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if sender.state == .selected {
            sender.imageView?.image = UIImage(systemName: "star.fill")
        } else {
            sender.imageView?.image = UIImage(systemName: "star")
        }
    }
}

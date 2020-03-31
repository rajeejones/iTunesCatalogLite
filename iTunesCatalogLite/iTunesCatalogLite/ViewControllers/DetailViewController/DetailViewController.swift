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
        StorageManager.favoriteItem(result) { [weak self] (success) in
            self?.displayFavoritedAlert(itemSaved: success, completion: {
                DispatchQueue.main.async {
                    sender.imageView?.image = UIImage(systemName: success ? "star.fill" : "star")
                }
            })
        }
    }
}

extension DetailViewController {
    func displayFavoritedAlert(itemSaved: Bool, completion: @escaping () -> Void ) {
        DispatchQueue.main.async { [weak self] in
            let title = itemSaved == true ? "Saved to Favorites" : nil
            let message = itemSaved == true ? nil : "There was an issue saving, please try again"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self?.present(alertController, animated: true, completion: completion)
        }
    }
}

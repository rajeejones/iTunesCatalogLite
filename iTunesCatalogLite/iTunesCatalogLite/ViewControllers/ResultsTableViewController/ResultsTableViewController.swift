//
//  ResultsTableViewController.swift
//  iTunesCatalog
//
//  Created by Rajee Jones on 3/31/20.
//  Copyright © 2020 OldMoonStudios. All rights reserved.
//

import UIKit
import iTunesCatalogLite_API

class ResultsTableViewController: UITableViewController {
    static var storyboardID = "ResultsTableViewController"

    var searchResult = [iTunesResultType : [iTunesSearchResult]]()

    @IBOutlet weak var resultsLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let nib = UINib(nibName: ResultTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ResultTableViewCell.reuseId)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.allowsSelectionDuringEditing = true
    }

    // MARK: - Table view data source

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
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.reuseId, for: indexPath) as? ResultTableViewCell

        let sectionKey = searchResult.keys.compactMap({ $0 })[indexPath.section]
        guard let resultsForSection = searchResult[sectionKey] else {
            return UITableViewCell()
        }

        let result = resultsForSection[indexPath.row]
        cell?.configure(result)
        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchResult.keys.compactMap({ $0 })[section].displayTitle
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionKey = searchResult.keys.compactMap({ $0 })[indexPath.section]
        guard let resultsForSection = searchResult[sectionKey] else {
            return
        }
        
        let selectedResult = resultsForSection[indexPath.row]
        let detailVC = DetailViewController.viewControllerForResult(selectedResult)
        self.present(detailVC, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

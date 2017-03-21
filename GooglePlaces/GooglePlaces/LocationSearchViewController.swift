//
//  LocationSearchViewController.swift
//  GooglePlaces
//
//  Created by Aniket Ghode on 18/03/17.
//  Copyright © 2017 Aniket Ghode. All rights reserved.
//

import UIKit
import SwiftyJSON

class LocationSearchViewController : UIViewController, UISearchResultsUpdating, UITableViewDataSource {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "Place"
    fileprivate let segueIdentifier = "ShowLocationDetails"
    @IBOutlet weak var tableView: UITableView!
    var searchController:UISearchController!
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tableView.dataSource = self
        setupSearchController()
    }
    
    // MARK: - Search Controller Helper Methods
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Search Controller Delegate Methods
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.characters.count >= 3 {
                // Fetch Google places for entered search text
                Service.sharedInstance.fetchGooglePlaces(forSearchString: searchText, completion: { (placeDataSource, err) in
                    if let err = err {
                        print("Error while fetching the places ",err)
                        return
                    }
                    self.places = placeDataSource!.places
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - Navigation - PrepareForSegue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! LocationDetailsViewController
                destinationController.selectedPlace = self.places[indexPath.row]
            }
        }
    }

    
    // MARK: - UITableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    

    
}

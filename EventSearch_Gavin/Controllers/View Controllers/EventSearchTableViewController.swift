//
//  EventSearchTableViewController.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//

import UIKit

class EventSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {return}
        EventController.searchTerm = searchBarText
        if searchBarText == "" || searchBarText == " "{
            EventController.fetchFavEvents()
            DispatchQueue.main.async {
                EventSearchTableViewController.arrayOfEvents = EventSearchTableViewController.favArray
                self.tableView.reloadData()
            }
        } else {
            EventController.fetchEvents { result in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    static let shared = EventSearchTableViewController()
    static var favArray: [Event] = []
    static var arrayOfEvents: [Event] = []
    var searchController = UISearchController()
    var resultSearchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        EventSearchTableViewController.arrayOfEvents = EventSearchTableViewController.favArray
        setUpSearchController()
    }
    
    var refresh: UIRefreshControl = UIRefreshControl()
    
    func setupViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull to load")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    func updateViews() {
        DispatchQueue.main.async {
            self.refresh.endRefreshing()
            self.tableView.reloadData()
        }
    }
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let eventSearchTable = storyboard.instantiateViewController(identifier: "main") as! EventSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: eventSearchTable)
        resultSearchController?.searchResultsUpdater = eventSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search upcoming events..."
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.rowHeight = 200
        print("Favorites \(EventSearchTableViewController.favArray.count)")
    }
    @objc func loadData() {
        EventController.fetchFavEvents()
        DispatchQueue.main.async {
            EventSearchTableViewController.arrayOfEvents = EventSearchTableViewController.favArray
            EventController.shared.funkDuplicates()
        }
        print("Favorites \(EventSearchTableViewController.favArray.count)")
        self.updateViews()
    }
    func lilLoad() {
        searchController.searchBar.text = " "
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventSearchTableViewController.arrayOfEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else {return UITableViewCell()}
        let event = EventSearchTableViewController.arrayOfEvents[indexPath.row]
        cell.event = event
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? EventDetailViewController else {return}
            let eventToSend = EventSearchTableViewController.arrayOfEvents[indexPath.row]
            destinationVC.event = eventToSend
        }
    }
}

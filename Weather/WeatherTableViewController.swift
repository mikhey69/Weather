//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by mikhey on 28.06.2018.
//  Copyright © 2018 mikhey. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var cities = [String]()
    var filterCitiesArray = [String]()
    var isSearching = false
    var searchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.JSON1()
        self.cities.sort()
        self.removeWrongCity()
        searchBar()
        
    }
    
    // JSON
    
    func JSON1() {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let array = json as? [Any] else { return }
            
            for city in array {
                guard let cityDict = city as? [String: Any] else { return }
                guard let cityName = cityDict["name"] as? String else { return }
                cities.append(cityName)
            }
        } catch  {
            print("Error")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.searchBar.text! == "" {
            return cities.count
        } else {
            
            return filterCitiesArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        text:
            if isSearching == true {
            cell.textLabel?.text =  filterCitiesArray[indexPath.row]
        }
        if isSearching == false {
            cell.textLabel?.text =  cities[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    // MARK: - Segue
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        performSegue(withIdentifier: "ShowCityWhether", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCityWhether" {
            
            let cityWhetherVC = segue.destination
                as! CityWhetherVC
            
            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            
            if isSearching == true {
                cityWhetherVC.cityName = filterCitiesArray[row]
            } else {
                cityWhetherVC.cityName = cities[row]
            }
            
        }
    }
    
    fileprivate func removeWrongCity() {
        for _ in 0...19 {
            cities.removeFirst()
        }
    }
    
    //search
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            filterCitiesArray = cities
            isSearching = false
            if isSearching == true {
            }
        } else {
            filterCitiesArray = cities.filter {
                $0.lowercased().contains("\(searchController.searchBar.text!.lowercased())")
            }
            isSearching = true
            if isSearching == false {
            }
        }
        tableView.reloadData()
    }
    fileprivate func searchBar() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
}

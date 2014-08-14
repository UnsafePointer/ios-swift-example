//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 12/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UITableViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    let tableViewCellIdentifier = "CityCell"
    let showCitySegueIdentifier = "ShowCity"
    let networkingHelper = NetworkingHelper()
    let locationManager = CLLocationManager()
    let databaseHelper = DatabaseHelper()
    var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == showCitySegueIdentifier) {
            let destination = segue.destinationViewController as CityViewController
            let city = cities[self.tableView.indexPathForSelectedRow().row]
            destination.city = city
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("onRefresh:"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func onRefresh(sender: AnyObject!) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            refreshControl.endRefreshing()
            let alert = UIAlertView(title: "Authorization required", message: "Please, authorize location in settings.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func loadCitiesWithUserLatitude(userLatitude: Double, userLongitude: Double) {
        networkingHelper.citiesWithUserLatitude(userLatitude, userLongitude: userLongitude) { (cities, error) -> () in
            self.refreshControl.endRefreshing()
            if let unwrappedError = error? {
                if unwrappedError.domain == NSURLErrorDomain && unwrappedError.code == NSURLErrorNotConnectedToInternet {
                    let alertView = UIAlertView(title: "Error", message: "Internet connection appears to be offline. Would you like to retrieve the last stored values?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                    alertView.show()
                }
            } else {
                self.cities.removeAll(keepCapacity: false)
                self.databaseHelper.storeCities(cities!)
                self.cities += cities!
                self.tableView.reloadData()
            }
        }
    }
    
    func loadCitiesFromDatabase() {
        databaseHelper.getStoredCities { (storedCities) -> () in
            self.cities.removeAll(keepCapacity: false)
            for city in storedCities {
                let typedCity = city as City
                self.cities.append(typedCity)
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count > 0 {
            let location: CLLocation = locations.first! as CLLocation
            locationManager.stopUpdatingLocation()
            loadCitiesWithUserLatitude(location.coordinate.latitude, userLongitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            onRefresh(self.refreshControl)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let city = cities[indexPath.row]
        tableViewCell.textLabel.text = city.name
        return tableViewCell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        performSegueWithIdentifier(showCitySegueIdentifier, sender: self)
    }
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        // alertView.firstOtherButtonIndex is not working as for Beta 5.
        if (1 == buttonIndex) {
            loadCitiesFromDatabase()
        }
    }

}
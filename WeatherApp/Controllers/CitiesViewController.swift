//
//  ViewController.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 12/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UITableViewController, CLLocationManagerDelegate {
    
    let networkingHelper = NetworkingHelper()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("onRefresh:"), forControlEvents: UIControlEvents.ValueChanged);
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
                println(unwrappedError.localizedDescription)
            } else {
                println("Success")
            }
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

}


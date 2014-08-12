//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 12/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import UIKit

class CityViewController: UITableViewController {
    
    var city: City!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLabels() {
        navigationItem.title = city.name
        temperatureLabel.text = String(format: "%.2f", city.temperature)
        pressureLabel.text = String(format: "%.2f", city.pressure)
        humidityLabel.text = String(format: "%.2f", city.humidity)
    }
    
}
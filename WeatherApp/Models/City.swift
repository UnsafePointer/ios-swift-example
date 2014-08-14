//
//  City.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 12/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import Foundation
import Realm

class City: RLMObject {
    
    dynamic var name = ""
    dynamic var temperature = 0.0
    dynamic var pressure = 0.0
    dynamic var humidity = 0.0
    
}
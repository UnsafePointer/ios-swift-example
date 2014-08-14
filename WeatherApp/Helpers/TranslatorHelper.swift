//
//  TranslatorHelper.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 12/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import Foundation

class TranslatorHelper {
    
    func translateCitiesFromJSON(data: AnyObject?) -> [City]? {
        if let unwrappedData = data as? NSData {
            let json = JSONValue(unwrappedData)
            if let jsonCities = json["list"].array {
                var cities = [City]()
                for jsonCity in jsonCities {
                    let city = City()
                    city.name = jsonCity["name"].string!
                    city.temperature = jsonCity["main"]["temp"].double!
                    city.pressure = jsonCity["main"]["pressure"].double!
                    city.humidity = jsonCity["main"]["humidity"].double!
                    cities.append(city)
                }
                return cities
            }
        }
        return nil
    }
    
}
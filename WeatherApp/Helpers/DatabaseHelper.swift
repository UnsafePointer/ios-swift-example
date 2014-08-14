//
//  DatabaseHelper.swift
//  WeatherApp
//
//  Created by Renzo Crisostomo on 14/08/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

import Foundation
import Realm

class DatabaseHelper {
    
    func storeCities(cities: [City]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let realm = RLMRealm.defaultRealm()
            let allCities = City.allObjectsInRealm(realm)
            realm.beginWriteTransaction()
            if allCities.count > 0 {
                realm.deleteObjects(allCities)
            }
            for city in cities {
                City.createInRealm(realm, withObject: ["name": city.name, "temperature": city.temperature, "pressure": city.pressure, "humidity": city.humidity])
            }
            realm.commitWriteTransaction()
        }
    }
    
    func getStoredCities(callback: (RLMArray)->()) {
        let realm = RLMRealm.defaultRealm()
        let allCities = City.allObjectsInRealm(realm)
        callback(allCities)
    }
    
}
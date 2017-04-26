////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

import Foundation

open class CityDaoUserDefaultsImpl : NSObject, CityDao {
    
    var defaults : UserDefaults
    let citiesListKey = "pfWeather.cities"
    let currentCityKey = "pfWeather.currentCityKey"
    
    let defaultCities = [
        "Manila",
        "Madrid",
        "San Francisco",
        "Phnom Penh",
        "Omsk"
    ]
    
    
    init(defaults : UserDefaults) {
        self.defaults = defaults
    }
    
    open func listAllCities() -> [AnyObject]! {
        
        var cities : NSArray? = self.defaults.array(forKey: self.citiesListKey) as NSArray?
        if (cities == nil) {
            cities = defaultCities as NSArray?;
            self.defaults.set(cities, forKey:self.citiesListKey)
        }

        let sorted = (cities as! [String]).sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 < s2
        })

        return sorted as [AnyObject]!
    }
    
    open func saveCity(_ name: String!) {

        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var savedCities : Array? = self.defaults.array(forKey: self.citiesListKey)
        if (savedCities == nil) {
            savedCities = defaultCities
        }
        
        let cities = NSMutableArray(array: savedCities!)
        
        var canAddCity = true
        for city in cities {
            if ((city as AnyObject).lowercased == trimmedName.lowercased()) {
                canAddCity = false
            }
        }
        if (canAddCity) {
            cities.add(trimmedName)
            self.defaults.set(cities, forKey: self.citiesListKey)
        }
    }
    
    open func deleteCity(_ name: String!) {
        
        let trimmedName = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let cities = NSMutableArray(array: self.defaults.array(forKey: self.citiesListKey)!)
        var cityToRemove : String?
        for city in cities {
            if ((city as AnyObject).lowercased == trimmedName.lowercased()) {
                cityToRemove = city as? String
            }
        }
        if (cityToRemove != nil)
        {
            cities.remove(cityToRemove!)
        }

        self.defaults.set(cities, forKey: self.citiesListKey)
    }
    
    open func saveCurrentlySelectedCity(_ cityName: String!) {
        
        let trimmed = cityName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!trimmed.isEmpty) {
            self.defaults.set(trimmed, forKey: self.currentCityKey)
        }
    }
    
    
    open func clearCurrentlySelectedCity() {
        
        self.defaults.set(nil, forKey: self.currentCityKey)
        
    }
    
    open func loadSelectedCity() -> String? {
        return self.defaults.object(forKey: self.currentCityKey) as? String
    }

    
}

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

open class WeatherReport : NSObject, NSCoding {
    
    open fileprivate(set) var city : String
    open fileprivate(set) var date : Date
    open fileprivate(set) var currentConditions : CurrentConditions
    open fileprivate(set) var forecast : Array<ForecastConditions>
    
    open var cityDisplayName : String {
        var displayName : String
        let components : Array<String> = self.city.components(separatedBy: ",")
        if (components.count > 1) {
            displayName = components[0]
        }
        else {
            displayName = self.city.capitalized
        }
        
        return displayName
    }
    
    
    public init(city : String, date : Date, currentConditions : CurrentConditions,
        forecast : Array<ForecastConditions>) {
        
        self.city = city
        self.date = date
        self.currentConditions = currentConditions
        self.forecast = forecast
    }
    
    public required init?(coder : NSCoder) {
        self.city = coder.decodeObject(forKey: "city") as! String
        self.date = coder.decodeObject(forKey: "date") as! Date
        self.currentConditions = coder.decodeObject(forKey: "currentConditions") as! CurrentConditions
        self.forecast = coder.decodeObject(forKey: "forecast") as! Array<ForecastConditions>
    }
    
    open func reportDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd',' yyyy 'at' hh:mm a"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self.date)
    }
    
    open override var description: String {
        return String(format: "Weather Report: city=%@, current conditions = %@, forecast=%@", self.city, self.currentConditions, self.forecast )
    }
    
    open func encode(with coder : NSCoder) {
        coder.encode(self.city, forKey:"city")
        coder.encode(self.date, forKey:"date")
        coder.encode(self.currentConditions, forKey:"currentConditions")
        coder.encode(self.forecast, forKey:"forecast")

    }

    

    
}

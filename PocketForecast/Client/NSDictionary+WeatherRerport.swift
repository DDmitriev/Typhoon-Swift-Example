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

class WeatherReportParser {
   
    public func parseError(json:[String: AnyObject]!) -> NSError? {

        if let errors = json["data"]?["error"] as? [AnyObject] {
            if let errorDict = errors[0] as? [String : String] {
                if let message = errorDict["msg"] {
                    return NSError(message: message)
                }
            }
        }
        return nil;
    }
    
    
    public func toWeatherReport(json:[String: AnyObject]!) -> WeatherReport {

        let data = json["data"] as! [String: AnyObject]

        let request = (data["request"] as! [[String: AnyObject]]).first!
        let city = request["query"] as! String

        let currentConditionsJson = (data["current_condition"] as! [[String: AnyObject]]).first!
        let currentConditions = self.toCurrentConditions(json: currentConditionsJson)

        var forecastConditions : Array<ForecastConditions> = []
        for item in data["weather"] as! [[String : AnyObject]] {
            forecastConditions.append(self.toForecastConditions(json: item))
        }
        return WeatherReport(city: city, date: Date(), currentConditions: currentConditions, forecast: forecastConditions)
    }
    
    public func toCurrentConditions(json:[String: AnyObject]!) -> CurrentConditions {
        
        let summary = (json["weatherDesc"] as! [[String : String]]).first!["value"]!
        let temperature = Temperature(fahrenheitString: json["temp_F"] as! String)
        let humidity = json["humidity"] as! String
        let wind = String(format: "Wind: %@ km %@", json["windspeedKmph"] as! String,
            json["winddir16Point"] as! String)
        let imageUri = (json["weatherIconUrl"] as!  [[String : String]]).first!["value"]!
        
        return CurrentConditions(summary: summary, temperature: temperature, humidity: humidity, wind: wind, imageUri: imageUri)
    }
    
    public func toForecastConditions(json:[String: AnyObject]!) -> ForecastConditions {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: json["date"] as! String)!
        
        var low: Temperature?
        if json["mintempF"] != nil {
            low = Temperature(fahrenheitString: json["mintempF"] as! String)
        }
                
        var high: Temperature?
        if json["maxtempF"] != nil {
           high = Temperature(fahrenheitString: json["maxtempF"] as! String)
        }

        let dayDetails = (json["hourly"] as! [[String: AnyObject]]).first!


        var description = ""
        if dayDetails["weatherDesc"] != nil {
          description = (dayDetails["weatherDesc"] as! [[String : String]]).first!["value"]!
        }
        
        var imageUri = ""
        if dayDetails["weatherIconUrl"] != nil {
            imageUri = (dayDetails["weatherIconUrl"] as! [[String : String]]).first!["value"]!
        }
        
        return ForecastConditions(date: date, low: low, high: high, summary: description, imageUri: imageUri)
    }
    
}


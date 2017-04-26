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

open class CurrentConditions : NSObject, NSCoding {
    
    fileprivate(set) var summary : String?
    fileprivate(set) var temperature : Temperature?
    fileprivate(set) var humidity : String?
    fileprivate(set) var wind : String?
    fileprivate(set) var imageUri : String?
    
    public init(summary : String, temperature : Temperature, humidity : String, wind : String, imageUri : String) {
        self.summary = summary
        self.temperature = temperature
        self.humidity = humidity
        self.wind = wind
        self.imageUri = imageUri
    }
    
    public required init?(coder : NSCoder) {
        self.summary = coder.decodeObject(forKey: "summary") as? String
        self.temperature = coder.decodeObject(forKey: "temperature") as? Temperature
        self.humidity = coder.decodeObject(forKey: "humidity") as? String
        self.wind = coder.decodeObject(forKey: "wind") as? String
        self.imageUri = coder.decodeObject(forKey: "imageUri") as? String
    }
    
    open func longSummary() -> String {
        return String(format: "%@. %@.", self.summary!, self.wind!)
    }
    
    open override var description: String {
        return String(format: "Current Conditions: summary=%@, temperature=%@", self.summary!, self.temperature!)
    }
    
    open func encode(with coder : NSCoder) {
        
        coder.encode(self.summary!, forKey:"summary")
        coder.encode(self.temperature!, forKey:"temperature")
        coder.encode(self.humidity!, forKey:"humidity")
        coder.encode(self.wind!, forKey:"wind")
        coder.encode(self.imageUri!, forKey:"imageUri")
    }
}

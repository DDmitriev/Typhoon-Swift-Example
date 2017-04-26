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

public enum TemperatureUnits : Int {
    case celsius
    case fahrenheit
}


open class Temperature : NSObject, NSCoding {
    
    fileprivate var _temperatureInFahrenheit : NSDecimalNumber
    fileprivate var _shortFormatter : NumberFormatter
    fileprivate var _longFormatter : NumberFormatter

    open class func defaultUnits() -> TemperatureUnits {
        return TemperatureUnits(rawValue: UserDefaults.standard.integer(forKey: "pf.default.units"))!
    }

    open class func setDefaultUnits(_ units : TemperatureUnits) {
        UserDefaults.standard.set(units.rawValue, forKey: "pf.default.units")
    }
    

  
    public init(temperatureInFahrenheit : NSDecimalNumber) {
        _temperatureInFahrenheit = temperatureInFahrenheit;
        
        _shortFormatter = NumberFormatter()
        _shortFormatter.minimumFractionDigits = 0;
        _shortFormatter.maximumFractionDigits = 0;
        
        _longFormatter = NumberFormatter()
        _longFormatter.minimumFractionDigits = 0
        _longFormatter.maximumFractionDigits = 1
        
    }
    
    public convenience init(fahrenheitString : String) {
        self.init(temperatureInFahrenheit:NSDecimalNumber(string: fahrenheitString))
    }
    
    public convenience init(celciusString : String) {
        let fahrenheit = NSDecimalNumber(string: celciusString)
            .multiplying(by: 9)
            .dividing(by: 5)
            .adding(32)
        self.init(temperatureInFahrenheit : fahrenheit)
    }
    
    public required convenience init?(coder : NSCoder) {
        let temp = coder.decodeObject(forKey: "temperatureInFahrenheit") as! NSDecimalNumber
        self.init(temperatureInFahrenheit: temp)
        
    }
    
    open func inFahrenheit() -> NSNumber {
        return _temperatureInFahrenheit;
    }
    
    open func inCelcius() -> NSNumber {
        return _temperatureInFahrenheit
            .subtracting(32)
            .multiplying(by: 5)
            .dividing(by: 9)
    }
    
    open func asShortStringInDefaultUnits() -> String {
        if (Temperature.defaultUnits() == TemperatureUnits.celsius) {
            return self.asShortStringInCelsius()
        }
        else {
            return self.asShortStringInFahrenheit()
        }
    }
    
    open func asLongStringInDefualtUnits() -> String {
        if (Temperature.defaultUnits() == TemperatureUnits.celsius) {
            return self.asLongStringInCelsius()
        }
        else {
            return self.asLongStringInFahrenheit()
        }
    }
    
    open func asShortStringInFahrenheit() -> String {
        return _shortFormatter.string(from: self.inFahrenheit())! + "°"
    }
    

    open func asLongStringInFahrenheit() -> String {
        return _longFormatter.string(from: self.inFahrenheit())! + "°"
    }
    
    open func asShortStringInCelsius() -> String {
        return _shortFormatter.string(from: self.inCelcius())! + "°"
    }
    
    open func asLongStringInCelsius() -> String {
        return _longFormatter.string(from: self.inCelcius())! + "°"
    }
    
    open override var description: String {
        return NSString(format: "Temperature: %@f [%@ celsius]", self.asShortStringInFahrenheit(),
            self.asShortStringInCelsius()) as String
    }
    
    open func encode(with coder : NSCoder) {
        coder.encode(_temperatureInFahrenheit, forKey:"temperatureInFahrenheit");
    }
    
    
}

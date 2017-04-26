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

open class WeatherReportDaoFileSystemImpl : NSObject, WeatherReportDao {
        
    open func getReportForCityName(_ cityName: String!) -> WeatherReport? {
        
        let filePath = self.filePathFor(cityName)
        let weatherReport : WeatherReport? = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? WeatherReport
        return weatherReport
    }
    
    open func saveReport(_ weatherReport: WeatherReport!) {
        
        NSKeyedArchiver.archiveRootObject(weatherReport, toFile: self.filePathFor(weatherReport.cityDisplayName))
    }

    
    fileprivate func filePathFor(_ cityName : String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] 
        let weatherReportKey = String(format: "weatherReport~>$%@", cityName)
        let filePath = documentsDirectory + weatherReportKey
        return filePath
    }
}

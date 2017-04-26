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

open class WeatherClientBasicImpl: NSObject, WeatherClient {

    var weatherReportDao: WeatherReportDao?
    var serviceUrl: URL?
    var daysToRetrieve: NSNumber?

    var apiKey: String? {
        willSet(newValue) {
            assert(newValue != "$$YOUR_API_KEY_HERE$$", "Please get an API key (v2) from: http://free.worldweatheronline.com, and then " +
                    "edit 'Configuration.plist'")
        }
    }

    open func loadWeatherReportFor(_ city: String!, onSuccess successBlock: ((WeatherReport?) -> Void)!, onError errorBlock: ((String?) -> Void)!) {


        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
            let url = self.queryURL(city)
            let data : Data! = try! Data(contentsOf: url)
            

            let dictionary = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [String : AnyObject]

            if let error = WeatherReportParser().parseError(json: dictionary) {
                DispatchQueue.main.async {
                    errorBlock(error.rootCause())
                    return
                }
            } else {
                let weatherReport: WeatherReport = WeatherReportParser().toWeatherReport(json: dictionary)
                self.weatherReportDao!.saveReport(weatherReport)
                DispatchQueue.main.async {
                    successBlock(weatherReport)
                    return
                }
            }
        }
    }


    fileprivate func queryURL(_ city: String) -> URL {

        let serviceUrl: URL = self.serviceUrl!
        let url: URL = (serviceUrl as NSURL).uq_URL(byAppendingQueryDictionary: [
                "q": city,
                "format": "json",
                "num_of_days": daysToRetrieve!.stringValue,
                "key": apiKey!,
                "tp": "24"
        ])

        return url
    }


}

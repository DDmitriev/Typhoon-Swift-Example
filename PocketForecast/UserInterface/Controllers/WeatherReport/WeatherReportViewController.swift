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

import UIKit


open class WeatherReportViewController: UIViewController {

    open var weatherReportView : WeatherReportView {
        get {
            return self.view as! WeatherReportView
        }
        set {
            self.view = newValue
        }
    }
    
    open fileprivate(set) var weatherClient : WeatherClient
    open fileprivate(set) var weatherReportDao : WeatherReportDao
    open fileprivate(set) var cityDao : CityDao
    open fileprivate(set) var assembly : ApplicationAssembly
    
    fileprivate var cityName : String?
    fileprivate var weatherReport : WeatherReport?
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    
    public dynamic init(view: WeatherReportView, weatherClient : WeatherClient, weatherReportDao : WeatherReportDao, cityDao : CityDao, assembly : ApplicationAssembly) {
        
        self.weatherClient = weatherClient
        self.weatherReportDao = weatherReportDao
        self.cityDao = cityDao
        self.assembly = assembly
            
        super.init(nibName: nil, bundle: nil)
        
        self.weatherReportView = view
                    
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.isNavigationBarHidden = true

        self.cityName = self.cityDao.loadSelectedCity()
        if (self.cityName != nil) {
            self.weatherReport = self.weatherReportDao.getReportForCityName(self.cityName)
            if (self.weatherReport != nil) {
                self.weatherReportView.weatherReport = self.weatherReport
            }
            else if (self.cityName != nil) {
                self.refreshData()
            }
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.cityName != nil) {
            
            let cityListButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(WeatherReportViewController.presentMenu))
            cityListButton.tintColor = UIColor.white
            
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.refresh, target: self, action: #selector(WeatherReportViewController.refreshData))
            refreshButton.tintColor = UIColor.white
            
            self.weatherReportView.toolbar.items = [
                cityListButton,
                space,
                refreshButton
            ]
        }
    }

    
    open override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
        super.viewWillDisappear(animated)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------

    fileprivate dynamic func refreshData() {
        ICLoader.present()
        
        self.weatherClient.loadWeatherReportFor(self.cityName, onSuccess: {
            (weatherReport) in
            
            self.weatherReportView.weatherReport = weatherReport
            ICLoader.dismiss()
            
            }, onError: {
                (message) in
                
                ICLoader.dismiss()
                print ("Error" + message!)
                
                
        })
    }
    
    fileprivate dynamic func presentMenu() {
        let rootViewController = self.assembly.rootViewController() as! RootViewController
        rootViewController.toggleSideViewController()
    }

   

}

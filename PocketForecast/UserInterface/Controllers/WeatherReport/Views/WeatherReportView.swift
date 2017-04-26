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

open class WeatherReportView : UIView, UITableViewDelegate, UITableViewDataSource, Themeable {
    
    fileprivate var backgroundView : UIImageView!
    fileprivate var cityNameLabel : UILabel!
    fileprivate var conditionsDescriptionLabel : UILabel!
    fileprivate var conditionsIcon : UIImageView!

    fileprivate var temperatureLabelContainer : UIView!
    fileprivate var temperatureLabel : UILabel!
    
    fileprivate var lastUpdateLabel : UILabel!
    fileprivate var tableView : UITableView!
    
    open var toolbar : UIToolbar!
    
    open var weatherReport : WeatherReport? {
        willSet(weatherReport) {
            
            if (weatherReport != nil) {
                self.tableView.isHidden = false
                self.conditionsIcon.isHidden = false
                self.temperatureLabelContainer.isHidden = false

                self.tableView.reloadData()
                self.cityNameLabel.text = weatherReport!.cityDisplayName
                self.temperatureLabel.text = weatherReport!.currentConditions.temperature!.asShortStringInDefaultUnits()
                self.conditionsDescriptionLabel.text = weatherReport!.currentConditions.longSummary()
                self.lastUpdateLabel.text = String(format: "Updated %@", weatherReport!.reportDateAsString())

            }
        }
    }
    
    open var theme : Theme! {
        willSet(theme) {
            DispatchQueue.main.async {
                self.toolbar.barTintColor = theme.forecastTintColor
                self.backgroundView.image = UIImage(named: theme.backgroundResourceName!)
                self.tableView.reloadData()
            }
        }
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------
    
    public override init(frame : CGRect) {
        super.init(frame : frame)
        
        self.initBackgroundView()
        self.initCityNameLabel()
        self.initConditionsDescriptionLabel()
        self.initConditionsIcon()
        self.initTemperatureLabel()
        self.initTableView()
        self.initToolbar()
        self.initLastUpdateLabel()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden methods
    //-------------------------------------------------------------------------------------------

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundView.frame = self.bounds.insetBy(dx: -10, dy: -10)
        
        self.cityNameLabel.frame = CGRect(x: 0, y: 60, width: self.frame.size.width, height: 40)
        self.conditionsDescriptionLabel.frame = CGRect(x: 0, y: 90, width: 320, height: 50)
        self.conditionsIcon.frame = CGRect(x: 40, y: 143, width: 130, height: 120)
        self.temperatureLabelContainer.frame = CGRect(x: 180, y: 155, width: 88, height: 88)
        
        self.toolbar.frame = CGRect(x: 0, y: self.frame.size.height - self.toolbar.frame.size.height, width: self.frame.size.width, height: self.toolbar.frame.size.height)
        self.tableView.frame = CGRect(x: 0, y: self.frame.size.height - self.toolbar.frame.size.height - 150, width: 320, height: 150)
        self.lastUpdateLabel.frame = self.toolbar.bounds

        
    }
    
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - UITableViewDelegate & UITableViewDataSource
    //-------------------------------------------------------------------------------------------
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "weatherForecast"
        var cell : ForecastTableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ForecastTableViewCell
        if (cell == nil) {
            cell = ForecastTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        if (self.weatherReport != nil && self.weatherReport!.forecast.count > indexPath.row) {
            let forecastConditions : ForecastConditions = self.weatherReport!.forecast[indexPath.row]
            cell!.dayLabel.text = forecastConditions.longDayOfTheWeek()
            cell!.descriptionLabel.text = forecastConditions.summary
            
            if forecastConditions.low != nil {
                cell!.lowTempLabel.text = forecastConditions.low!.asShortStringInDefaultUnits()
            }
            
            if forecastConditions.high != nil {
                cell!.highTempLabel.text = forecastConditions.high!.asShortStringInDefaultUnits()
            }
            
            cell!.conditionsIcon.image = self.uiImageForImageUri(forecastConditions.imageUri)
            cell!.backgroundView?.backgroundColor = self.colorForRow(indexPath.row)
        }
        return cell!
    }
    

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
       cell.backgroundColor = UIColor.clear
    }
  
        
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------
    
    fileprivate func initBackgroundView() {
        self.backgroundView = UIImageView(frame: CGRect.zero)
        self.backgroundView.contentMode = .scaleToFill
        self.backgroundView.parallaxIntensity = 20
        self.addSubview(self.backgroundView)
    }
    
    fileprivate func initCityNameLabel() {
        self.cityNameLabel = UILabel(frame: CGRect.zero)
        self.cityNameLabel.font = UIFont.applicationFontOfSize(35)
        self.cityNameLabel.textColor = UIColor(hexRGB: 0xf9f7f4)
        self.cityNameLabel.backgroundColor = UIColor.clear
        self.cityNameLabel.textAlignment = .center
        self.addSubview(self.cityNameLabel)
    }
    
    fileprivate func initConditionsDescriptionLabel() {
        self.conditionsDescriptionLabel = UILabel(frame: CGRect.zero)
        self.conditionsDescriptionLabel.font = UIFont.applicationFontOfSize(16)
        self.conditionsDescriptionLabel.textColor = UIColor(hexRGB: 0xf9f7f4)
        self.conditionsDescriptionLabel.backgroundColor = UIColor.clear
        self.conditionsDescriptionLabel.textAlignment = NSTextAlignment.center
        self.conditionsDescriptionLabel.numberOfLines = 0
        self.addSubview(self.conditionsDescriptionLabel)
    }
    
    fileprivate func initConditionsIcon() {
        self.conditionsIcon = UIImageView(frame: CGRect.zero)
        self.conditionsIcon.image = UIImage(named: "icon_cloudy")
        self.conditionsIcon.isHidden = true
        self.addSubview(self.conditionsIcon)
    }
    
    fileprivate func initTemperatureLabel() {
        self.temperatureLabelContainer = UIView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
        self.addSubview(self.temperatureLabelContainer)
        
        let labelBackground = UIImageView(frame: self.temperatureLabelContainer.bounds)
        labelBackground.image = UIImage(named: "temperature_circle")
        self.temperatureLabelContainer.addSubview(labelBackground)
        
        self.temperatureLabel = UILabel(frame: self.temperatureLabelContainer.bounds)
        self.temperatureLabel.font = UIFont.temperatureFontOfSize(35)
        self.temperatureLabel.textColor = UIColor(hexRGB: 0x7f9588)
        self.temperatureLabel.backgroundColor = UIColor.clear
        self.temperatureLabel.textAlignment = .center
        self.temperatureLabelContainer.addSubview(temperatureLabel)
        
        self.temperatureLabelContainer.isHidden = true
    }
    
    fileprivate func initTableView() {
        self.tableView = UITableView(frame: CGRect.zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.isUserInteractionEnabled = false
        self.tableView.isHidden = true
        self.addSubview(self.tableView)
    }
    
    fileprivate func initToolbar() {
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        self.addSubview(self.toolbar)
    }
    
    fileprivate func initLastUpdateLabel() {
        self.lastUpdateLabel = UILabel(frame: CGRect.zero)
        self.lastUpdateLabel.font = UIFont.applicationFontOfSize(10)
        self.lastUpdateLabel.textColor = UIColor(hexRGB: 0xf9f7f4)
        self.lastUpdateLabel.backgroundColor = UIColor.clear
        self.lastUpdateLabel.textAlignment = .center
        self.toolbar.addSubview(self.lastUpdateLabel)
    }
    
    fileprivate func colorForRow(_ row : Int) -> UIColor {
        switch (row) {
        case 0:
            return self.theme.forecastTintColor!.withAlphaComponent(0.55)
        case 1:
            return self.theme.forecastTintColor!.withAlphaComponent(0.75)
        default:
            return self.theme.forecastTintColor!.withAlphaComponent(0.95)
        }
    }
    
    //TODO: Make this proper Swift
    fileprivate func uiImageForImageUri(_ imageUri : String?) -> UIImage {
        var result: UIImage?
        if (imageUri != nil && imageUri!.characters.count > 0) {
            
            if (imageUri!.hasSuffix("sunny.png"))
            {
                result = UIImage(named:"icon_sunny")
            }
            else if (imageUri!.hasSuffix("sunny_intervals.png"))
            {
                result =  UIImage(named:"icon_cloudy")
            }
            else if (imageUri!.hasSuffix("partly_cloudy.png"))
            {
                result =  UIImage(named:"icon_cloudy")
            }
            else if (imageUri!.hasSuffix("low_cloud.png"))
            {
                result =  UIImage(named:"icon_cloudy")
            }
            else if (imageUri!.hasSuffix("rain.png"))
            {
                result =  UIImage(named:"icon_rainy")
            }
            else if (imageUri!.hasSuffix("showers.png"))
            {
                result =  UIImage(named:"icon_rainy")
            }
        }
        
        if result == nil {
            result = UIImage(named: "icon_sunny")
        }
        
        return result!

    }
        
}

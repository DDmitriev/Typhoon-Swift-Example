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

open class ForecastTableViewCell : UITableViewCell {
    
    fileprivate var overlayView : UIImageView!
    open fileprivate(set) var dayLabel : UILabel!
    open fileprivate(set) var descriptionLabel : UILabel!
    open fileprivate(set) var highTempLabel : UILabel!
    open fileprivate(set) var lowTempLabel : UILabel!
    open fileprivate(set) var conditionsIcon : UIImageView!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initBackgroundView()
        self.initOverlay()
        self.initConditionsIcon()
        self.initDayLabel()
        self.initDescriptionLabel()
        self.initHighTempLabel()
        self.initLowTempLabel()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------
    
    fileprivate func initBackgroundView() {
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor(hexRGB: 0x837758)
        self.backgroundView = backgroundView
    }
    
    fileprivate func initOverlay() {
        self.overlayView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        self.overlayView.image = UIImage(named: "cell_fade")
        self.overlayView.contentMode = .scaleToFill
        self.addSubview(self.overlayView)
    }
    
    fileprivate func initConditionsIcon() {
        self.conditionsIcon = UIImageView(frame:CGRect(x: 6, y: 7, width: (60 - 12), height: (50 - 12)))
        self.conditionsIcon.clipsToBounds = true
        self.conditionsIcon.contentMode = .scaleAspectFit
        self.conditionsIcon.image = UIImage(named: "icon_cloudy")
        self.addSubview(self.conditionsIcon)
    }
    
    fileprivate func initDayLabel() {
        self.dayLabel = UILabel(frame: CGRect(x: 70, y: 10, width: 150, height: 18))
        self.dayLabel.font = UIFont.applicationFontOfSize(16)
        self.dayLabel.textColor = UIColor.white
        self.dayLabel.backgroundColor = UIColor.clear
        self.addSubview(self.dayLabel)
    }
    
    fileprivate func initDescriptionLabel() {
        self.descriptionLabel = UILabel(frame:CGRect(x: 70, y: 28, width: 150, height: 16))
        self.descriptionLabel.font = UIFont.applicationFontOfSize(13)
        self.descriptionLabel.textColor = UIColor(hexRGB: 0xe9e1cd)
        self.descriptionLabel.backgroundColor = UIColor.clear
        self.addSubview(self.descriptionLabel)
    }
    
    fileprivate func initHighTempLabel() {
        self.highTempLabel = UILabel(frame: CGRect(x: 210, y: 10, width: 55, height: 30))
        self.highTempLabel.font = UIFont.temperatureFontOfSize(27)
        self.highTempLabel.textColor = UIColor.white
        self.highTempLabel.backgroundColor = UIColor.clear
        self.highTempLabel.textAlignment = NSTextAlignment.right
        self.addSubview(self.highTempLabel)
    }
    
    fileprivate func initLowTempLabel() {
        self.lowTempLabel = UILabel(frame: CGRect(x: 270, y: 11.5, width: 40, height: 30))
        self.lowTempLabel.font = UIFont.temperatureFontOfSize(20)
        self.lowTempLabel.textColor = UIColor(hexRGB: 0xd9d1bd)
        self.lowTempLabel.backgroundColor = UIColor.clear
        self.lowTempLabel.textAlignment = NSTextAlignment.right
        self.addSubview(self.lowTempLabel)
    }    
    
}

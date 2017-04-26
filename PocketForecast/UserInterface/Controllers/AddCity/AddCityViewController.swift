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

class AddCityViewController: UIViewController, UITextFieldDelegate, Themeable {
    
    //Typhoon injected properties
    
    var cityDao : CityDao!
    var weatherClient : WeatherClient!
    var theme : Theme!
    var rootViewController : RootViewController!
    
    //Interface Builder injected properties
    
    @IBOutlet var nameOfCityToAdd: UITextField!
    @IBOutlet var validationMessage : UILabel!
    @IBOutlet var spinner : UIActivityIndicatorView!

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required override init(nibName : String!, bundle : Bundle!)
    {
        NSLog("yehay!!!!!!!!!!!!!!!!!!!!!")
        super.init(nibName: nibName, bundle: bundle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        
        self.nameOfCityToAdd.font = UIFont.applicationFontOfSize(16)
        self.validationMessage.font = UIFont.applicationFontOfSize(16)
        self.title = "Add City"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddCityViewController.doneAdding(_:)))
        self.nameOfCityToAdd.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.validationMessage.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.doneAdding(textField)
        return true
    }
        
    fileprivate dynamic func doneAdding(_ textField : UITextField) {
        if (!self.nameOfCityToAdd.text!.isEmpty) {
            self.validationMessage.text = "Validating city . ."
            self.validationMessage.isHidden = false
            self.nameOfCityToAdd.isEnabled = false
            self.spinner.startAnimating()
            
            self.weatherClient.loadWeatherReportFor(self.nameOfCityToAdd.text, onSuccess: {
                (weatherReport) in
                
                self.cityDao!.saveCity(weatherReport?.cityDisplayName)
                self.rootViewController.dismissAddCitiesController()
                
                }, onError: {
                    (message) in
                    
                    self.spinner.stopAnimating()
                    self.nameOfCityToAdd.isEnabled = true
                    self.validationMessage.text = String(format: "No weather reports for '%@'.", self.nameOfCityToAdd.text!)
            })
        }
        else {
            self.nameOfCityToAdd.resignFirstResponder()
            self.rootViewController.dismissAddCitiesController()
        }
    }
    
    fileprivate func applyTheme() {
        print (String(format:"In apply theme: %@", self.theme!))
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.barTintColor = self.theme.navigationBarColor
    }
        
}

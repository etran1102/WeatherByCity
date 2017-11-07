//
//  CurrentWeather.swift
//  WeatherByCity
//
//  Created by Erick Tran on 10/10/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    //Declare variables
    var _city: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    var _currentIcon: String!
    
    var city: String {
        if _city == nil {
            _city = ""
        }
        return _city
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "\(currentDate)"
        
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var currentIcon: String {
        if _currentIcon == nil {
            _currentIcon = ""
        }
        return _currentIcon
    }
    
    //Initiate CurrentWeather object
    init(dict: Dictionary<String,Any>) {
        //get city name
        if let name = dict["name"] as? String {
            self._city = name.capitalized
        }
            
        //get current weather description
        if let weather = dict["weather"] as? [Dictionary<String, Any>] {
            //get current description
            if let main = weather[0]["description"] as? String {
                self._weatherType = main.capitalized
            }
            //get current icon descrition
            if let icon = weather[0]["icon"] as? String {
                self._currentIcon = icon
            }
        }
        
        //get current temperature
        if let main = dict["main"] as? Dictionary<String, Any> {
            if let currentTemperature = main["temp"] as? Double {
                let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                self._currentTemp = kelvinToFarenheit
            }
        }
    }
}

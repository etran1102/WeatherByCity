//
//  Forecast.swift
//  WeatherByCity
//
//  Created by Erick Tran on 10/10/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    //Declare Variable
    var _date: String!
    var _weatherType: String!
    var _temp: String!
    var _iconCondition: String!
    var _windSpeed: String!
    
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = ""
        }
        return _windSpeed
    }
    
    var temp: String {
        if _temp == nil {
            _temp = ""
        }
        return _temp
    }
    
    var iconCondition: String {
        if _iconCondition == nil {
            _iconCondition = ""
        }
        return _iconCondition
    }
    
    
    //Initiate Forecast object
    init(weatherDictionary: Dictionary<String, Any>) {
        
        //get temperature vavue
        if let temp = weatherDictionary["main"] as? Dictionary<String, Any> {
            
            if let min = temp["temp"] as? Double {
                let kelvinToFarenheitTemp = (min * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitTemp/10))
                self._temp = "\(kelvinToFarenheit)"
            }
        }
        
        //get wind speed value
        if let wind = weatherDictionary["wind"] as? Dictionary<String, Any> {
            if let tempSpeed = wind["speed"] as? Double {
                let speed = tempSpeed/0.44704
                self._windSpeed = "\(Double(round(10 * speed/10))) mi/hr "
            }
        }
        
        //get condition value
        if let weatherType = weatherDictionary["weather"] as? [Dictionary<String, Any>] {
             if let main = weatherType[0]["description"] as? String {
                 self._weatherType = main.capitalized
             }
            if let tempIcon = weatherType[0]["icon"] as? String {
                self._iconCondition = tempIcon
            }
        }
        
        //get date and time 
        if let date = weatherDictionary["dt"] as? Double {
            let unixConnvertedDate = Date(timeIntervalSince1970: date)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "EEE hh:mm a"
            let dateString = dayTimePeriodFormatter.string(from: unixConnvertedDate)
            self._date = dateString
        }
    }
}






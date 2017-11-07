//
//  WeatherCell.swift
//  WeatherByCity
//
//  Created by Erick Tran on 10/10/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Foundation

class WeatherCell: UITableViewCell {

    //Declare variables
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    //function to confure weather cells
    func configureCell(forecast: Forecast) {
        
        //set variables for display
        temp.text = "\(forecast.temp)°F"
        windSpeed.text = String(forecast.windSpeed)
        weatherType.text = forecast.weatherType
        dayLbl.text = forecast.date
        
        //use async to download image on a different thread in the background
        DispatchQueue.global().async {
            //use do try catch to download image
            do {
                let url = URL(string: "http://openweathermap.org/img/w/\(forecast.iconCondition).png")
                let data = try Data(contentsOf: url!)
                //give image back to main thread
                DispatchQueue.global().sync {
                    self.weatherIcon.image = UIImage(data: data)
                }
            } catch {
                //catch if image failed to download
                print("Image for cell can't be download")
            }
        }
        
    }

}

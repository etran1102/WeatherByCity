//
//  MainVC.swift
//  WeatherByCity
//
//  Created by Erick Tran on 10/10/17.
//  Copyright © 2017 Erick Tran. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Declare variables
    @IBOutlet weak var enterCityTextField: UITextField!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentWeatherLogo: UIImageView!
    @IBOutlet weak var currentCityLbl: UILabel!
    @IBOutlet weak var currentConditionLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentTempBtn: UIButton!

    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    var FehrenheitFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate and datasource for tableview
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //retrieve last city
        var city = UserDefaults.standard.object(forKey: "city")
        
        //check if last city exist, set to San Jose if not.
        if city == nil {
            city = "San-Jose"
        }
        
        //alamo request for current weather
        let currentWeatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=\(city!),us&appid=5cd8b4ef1da7d77afbf0eabb3f60a90e"
        Alamofire.request(currentWeatherUrl).responseJSON { response in
            let result = response.result
            
            //create current weather object and update UI
            if let dict = result.value as? Dictionary<String, Any> {
                self.currentWeather = CurrentWeather(dict: dict)
                self.updateMainUI()
            }
        }
        
        //alamo  request for tableview
        let forecastURL = "http://api.openweathermap.org/data/2.5/forecast?q=\(city!),us&appid=5cd8b4ef1da7d77afbf0eabb3f60a90e"
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            
            //create weather cells objects
            if let dict = result.value as? Dictionary<String, Any> {
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    for object in list {
                        let forecast = Forecast(weatherDictionary: object)
                        //add weather cells to forcasts array
                        self.forecasts.append(forecast)
                    }
                    //reload data in table
                    self.tableView.reloadData()
                }
            }
        }
        
        //with more time and resources I would like to add a daily report and present them in the app under a different table.
        //possibly using coredata to load multiple city and making an array of screen that allow to swiping to view a different city.
    }
    
    //number of sections for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows for table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    //configure the table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            //configure cell for specific row
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            //return empty cell
            return WeatherCell()
        }

    }

    //Update the UI for current weather condition
    func updateMainUI() {
        
        //set value for new UI
        dateLbl.text = currentWeather.date
        currentTempBtn.setTitle("\(currentWeather.currentTemp)°", for: .normal)
        currentConditionLbl.text = currentWeather.weatherType
        currentCityLbl.text = currentWeather.city
        
        //using asyn to download image in the background with a different thread
        DispatchQueue.global().async {
            
            //use do try catch to catch any error possible and prevent from crashing
            do {
                let url = URL(string: "http://openweathermap.org/img/w/\(self.currentWeather.currentIcon).png")
                let data = try Data(contentsOf: url!)
                
                //I would like to add the animation for  the appear of the image. I am thinking about making it fade in.
                //give image data back to main thread and UI
                DispatchQueue.global().sync {
                    self.currentWeatherLogo.image = UIImage(data: data)
                }
            } catch {
                //print error if failed to download image
                print("Can't download icon for current weather")
            }
        }
    }

    //action for when the search button is press
    @IBAction func searchCityPressed(_ sender: Any) {
        view.endEditing(true)
        if (enterCityTextField.text != nil) || (enterCityTextField.text == "") {
            var tempCity = enterCityTextField.text
            //delete old value and save a new one
            tempCity = tempCity!.replacingOccurrences(of: " ", with: "-")
            UserDefaults.standard.removeObject(forKey: "city")
            UserDefaults.standard.set(tempCity!, forKey: "city")
            //reload the screen
            self.viewWillAppear(true)
        } else {
            createAlert(title: "Uh-oh", message: "Please enter a city!")            
        }
    }
    
    //Toggle between Celcius and Fehrenheit for current temperature
    @IBAction func currentTempBtnPressed(_ sender: Any) {
        if FehrenheitFlag == true {
            let temporaryTemp = ((currentWeather.currentTemp - 32) * 5/9)
            let tempString = "\(round(Double(10 * temporaryTemp/10)))°c"
            currentTempBtn.setTitle(tempString, for: .normal)
            FehrenheitFlag = false
        } else {
            currentTempBtn.setTitle("\(currentWeather.currentTemp)°", for: .normal)
            FehrenheitFlag = true
        }
        
        
        
    }
    //create alert to notice user when something went wrong.
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


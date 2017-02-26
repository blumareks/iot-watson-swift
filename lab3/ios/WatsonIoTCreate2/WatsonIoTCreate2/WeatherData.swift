//
//  WeatherData.swift
//  WatsonIoTCreate2
//
//  Created by Marek Sadowski on 2/25/17.
//  Copyright © 2017 Marek Sadowski. All rights reserved.
//

import Foundation
import BMSCore //querrying Bluemix for Weather Company Data
import SwiftyJSON //working with JSON with Weather forecast

class WeatherData {
    let location = "94596%3A4%3AUS" //find the weather forecast for a zip
    let username: String
    let password: String
    let host: String
    
    var temp0 = 0
    var golf0 = ""
    
    init() {
        username = "Weather Company Data user name from bluemix"
        password = "Weather Company Data password from bluemix"
        host = "twcservice.mybluemix.net"
    }
    
    func getGolf() -> String{
        return "there is a forecast for the temperature \(self.temp0) and the \(self.golf0) golf conditions"
    }
    
    func getCurrentWeather() {
        
        let url = "https://" + host + "/api/weather/v1/location/\(location)/forecast/hourly/48hour.json"
        let basicAuth = "Basic " + "\(username):\(password)".toBase64()
        let headers = ["Authorization" : basicAuth]
        
        
        let request = Request(url: url,
                              method: .GET,
                              headers: headers)
        NSLog("sending request")
        request.send { (response, error) in
            if let error = error {
                NSLog("error sending request")
                print(error)
                return
            }
            guard let response = response else {
                return
            }
            if response.isSuccessful {
                //print(response.responseText!) //what we got from Weather Company Data
                let data = response.responseText!.data(using: String.Encoding.utf8)
                let json = JSON(data: data!)
                //print(json["forecasts"]) //JSON
                let forecasts = json["forecasts"].arrayValue
                self.temp0 = forecasts[0]["temp"].intValue
                self.golf0 = forecasts[0]["golf_category"].stringValue
                NSLog("end of weather company data call : golf0 - temp0")
            } else {
                if response.statusCode! == 401 {
                    print("Failed to connect to the Weather Company Data service due to invalid credentials. Please verify your credentials in the WeatherCredentials.plist file and rebuild the application. See the README for further assistance.")
                } else {
                    print("Failed Request to Weather Service :: Status: \(response.statusCode), Message: \(response.responseText!)")
                }
            }
        }
        
    }
    
}

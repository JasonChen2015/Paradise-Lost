//
//  JsonParser.swift
//  Paradise Lost
//
//  Created by jason on 21/4/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import Foundation
import CoreLocation

class ForecastManager {
    static let shareInstance = ForecastManager()
    
    // MARK: https://darksky.net
    
    private let darkskyLink = "https://api.darksky.net/forecast/"
    
    private let darkskyKey = "cb16118455c632ec0de548eda02d6570"
    
    private var darksky: Forecast?
    
    func setJSON(data: Data?) {
        do {
            let darkskyJSON = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: AnyObject]
            darksky = Forecast(fromJSON: darkskyJSON)
        } catch {
            // handle error
            print(error)
        }
    }
    
    func getDarkSkyLink(_ latitude: Double, _ longitude: Double) -> String {
        return darkskyLink + darkskyKey + "/" + String(latitude) + "," + String(longitude)
    }
    
    // MARK: temperature conversion
    
    func fahrenheitToCelsius(temp: Double) -> Double {
        return (temp - 32) * 5 / 9
    }
    
    func celsiusToFahrenheit(temp: Double) -> Double {
        return temp * 1.8 + 32
    }
    
    // MARK: getters and setters
    
    func getWeatherIcon() -> String? {
        return darksky?.icon
    }
    
    func getTime() -> Date? {
        return darksky?.time
    }
    
    func getSummary() -> String? {
        return darksky?.summary
    }
    
    func getTemperature(inCelsius: Bool) -> Double? {
        if inCelsius {
            if let t = darksky?.temperature {
                return fahrenheitToCelsius(temp: t)
            } else {
                return nil
            }
        } else {
            return darksky?.temperature
        }
    }
}


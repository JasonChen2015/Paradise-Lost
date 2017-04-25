//
//  Forecast.swift
//  Paradise Lost
//
//  Created by jason on 21/4/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum WeatherIcon {
    case none
    case clearDay
    case clearNight
    case rain
    case snow
    case sleet
    case wind
    case fog
    case cloudy
    case partlyCloudyDay
    case partlyCloudyNight
}

struct Forecast {
    
    var location: CLLocation?
    
    // get below info from currently
    
    /// forecast time (seconds since the Epoch (00:00:00 UTC, January 1, 1970))
    var time: Date?
    
    /// A machine-readable text summary of this data point, suitable for selecting an icon for display.
    var icon: String?
    
    /// A human-readable text summary of this data point.
    var summary: String?
    
    /// The intensity (in inches of liquid water per hour) of precipitation occurring at the given time.
    var precipIntensity: Double?
    
    /// The air temperature in degrees Fahrenheit.
    var temperature: Double?
    
    /// The average visibility in miles, capped at 10 miles.
    var visibility: Double?
    
    /// The wind speed in miles per hour.
    var windSpeed: Double?
    
    init() {
        time = nil
        icon = nil
        summary = nil
        precipIntensity = nil
        temperature = nil
        visibility = nil
        windSpeed = nil
    }
    
    init(fromJSON json: [String: AnyObject]) {
        if let lat = json["latitude"] as? CLLocationDegrees, let lon = json["longitude"] as? CLLocationDegrees {
            location = CLLocation(latitude: lat, longitude: lon)
        } else {
            location = nil
        }
        if let currentDic = json["currently"] as? [String: AnyObject] {
            if let ttime = currentDic["time"] as? Double {
                time = Date(timeIntervalSince1970: ttime)
            } else { time = nil }
            if let ticon = currentDic["icon"] as? String {
                icon = ticon
            } else { icon = nil }
            if let tsummary = currentDic["summary"] as? String {
                summary = tsummary
            } else { summary = nil }
            if let tprecipIntensity = currentDic["precipIntensity"] as? Double {
                precipIntensity = tprecipIntensity
            } else { precipIntensity = nil }
            if let ttemperature = currentDic["temperature"] as? Double {
                temperature = ttemperature
            } else { temperature = nil }
            if let tvisibility = currentDic["visibility"] as? Double {
                visibility = tvisibility
            } else { visibility = nil }
            if let twindSpeed = currentDic["windSpeed"] as? Double {
                windSpeed = twindSpeed
            } else { windSpeed = nil }
        }
    }
}

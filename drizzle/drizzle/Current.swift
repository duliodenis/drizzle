//
//  Current.swift
//  drizzle
//
//  Created by Dulio Denis on 9/24/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import Foundation

struct Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipitationProbability: Double
    var summary: String
    var icon: String
    
    init(weatherDictionary: NSDictionary) {
        let currentWeather : NSDictionary = weatherDictionary["currently"] as NSDictionary
        
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipitationProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        icon = currentWeather["icon"] as String
        
        let currentTimeInt = currentWeather["time"] as Int
        currentTime = dateStringFromUnixTime(currentTimeInt)
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
}
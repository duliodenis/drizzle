//
//  ViewController.swift
//  drizzle
//
//  Created by Dulio Denis on 9/23/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "YOUR-FORECAST-API-KEY"
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinates = "40.7606,-73.984" // Initial Coordinates
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: coordinates, relativeToURL: baseURL)
        let weatherData = NSData.dataWithContentsOfURL(forecastURL, options: nil, error: nil)
        println(weatherData)
    }

}


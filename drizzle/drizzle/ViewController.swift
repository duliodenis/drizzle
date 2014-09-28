//
//  ViewController.swift
//  drizzle
//
//  Created by Dulio Denis on 9/23/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    private let apiKey = "YOUR-FORECAST-API-KEY"
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinates = "40.7606,-73.984" // Initial Coordinates
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: coordinates, relativeToURL: baseURL)
        let weatherData = NSData.dataWithContentsOfURL(forecastURL, options: nil, error: nil)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let currentWeatherDictionary = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeatherDictionary.temperature)"
                    self.iconView.image = currentWeatherDictionary.icon!
                    self.currentTimeLabel.text = "At \(currentWeatherDictionary.currentTime!) it is"
                    self.temperatureLabel.text = "\(currentWeatherDictionary.temperature)"
                    self.humidityLabel.text = "\(currentWeatherDictionary.humidity)"
                    self.precipitationLabel.text = "\(currentWeatherDictionary.precipitationProbability)"
                    self.summaryLabel.text = "\(currentWeatherDictionary.summary)"
                })
                
            }
            
        })
        downloadTask.resume()
    }

}


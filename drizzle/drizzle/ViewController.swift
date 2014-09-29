//
//  ViewController.swift
//  drizzle
//
//  Created by Dulio Denis on 9/23/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Weather Properties
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    var coordinates = "40.7606,-73.984" // Initial Coordinates
    
    private let apiKey = "YOUR-FORECAST-API-KEY"
    
    // MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
    }

    
    // MARK: Fetch Weather Data Methods
    
    func getCurrentWeatherData() -> Void {
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
                    
                    // stop the activity indicator animation and put back the refresh button
                    self.stopActivityIndicator()
                })
                
            } else {
                let networkIssueController = UIAlertController(title: "Error",
                    message: "Unable to load data due to a connectivity error.",
                    preferredStyle: .Alert)
                let dismissButton = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                networkIssueController.addAction(dismissButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopActivityIndicator()
                })
                
            }
            
        })
        downloadTask.resume()
    }
    
    
    @IBAction func refresh() {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    
    
    func stopActivityIndicator() -> Void {
        // stop the activity indicator animation and put back the refresh button
        self.refreshButton.hidden = false
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
    }

}


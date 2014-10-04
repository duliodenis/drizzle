//
//  ViewController.swift
//  drizzle
//
//  Created by Dulio Denis on 9/23/14.
//  Copyright (c) 2014 Dulio Denis. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Weather Properties
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var locationReceived = false
    var coordinates = "40.7606,-73.984" // Initial Coordinates
    
    private let apiKey = "YOUR-FORECAST-API-KEY"
    
    // MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
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
                var jsonError: NSError?
                let dataObject = NSData(contentsOfURL: location)
                let json : AnyObject! = NSJSONSerialization.JSONObjectWithData(dataObject, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
                if let err = jsonError {
                    
                    let jsonIssueController = UIAlertController(title: "Sorry Dude",
                        message: "Unable to acquire weather data due to a weather server issue.",
                        preferredStyle: .Alert)
                    let dismissButton = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                    jsonIssueController.addAction(dismissButton)
                    
                    self.presentViewController(jsonIssueController, animated: true, completion: nil)
                    
                    return
                }
                
                var weatherDictionary = json as NSDictionary
                
               // let weatherDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let currentWeatherDictionary = Current(weatherDictionary: weatherDictionary)
                self.locationManager.startUpdatingLocation()
                
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
                let networkIssueController = UIAlertController(title: "Sorry but",
                    message: "Unable to load data due to a connectivity error. Try later, dude.",
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
        locationReceived = false
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
    
    
    func stopActivityIndicator() -> Void {
        // stop the activity indicator animation and put back the refresh button
        self.refreshButton.hidden = false
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        if (locationReceived) {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: Location Manager Delegate Functions
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
       println("An error occurred: \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        coordinates = "\(locValue.latitude),\(locValue.longitude)"
        locationReceived = true
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                return
            }
            
            if placemarks.count > 0 {
                self.cityLabel.text = placemarks[0].locality
            }
        })
    
        getCurrentWeatherData()
    }
    
    
    

}


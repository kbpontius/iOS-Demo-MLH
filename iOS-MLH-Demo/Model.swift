//
//  Model.swift
//  iOS-MLH-Demo
//
//  Created by Kyle on 10/10/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import Foundation
import UIKit

class Model: ErrorHandlingDelegate {
    private var locator:Locator?
    private let errorHandling: ErrorHandlingDelegate! // This comes from the ViewController.
    
    var currentTemp = ""
    var currentStatus = ""
    var currentHumidity = ""
    var currentChanceRain = ""
    var currentLocation = ""
    var icon:UIImage?
    
    init(errorHandlerDelegate: ErrorHandlingDelegate) {
        self.errorHandling = errorHandlerDelegate
    }
    
    func parseWeatherInformation(currentWeather: NSDictionary) {
        print(currentWeather)
        currentTemp = String(currentWeather["temperature"] as! Int)
        currentHumidity = String(currentWeather["humidity"] as! Double)
        currentChanceRain = String(currentWeather["precipProbability"] as! Double)
        currentStatus = currentWeather["summary"] as! String
        
        let iconString = currentWeather["icon"] as! String
        icon = weatherIconFromString(iconString)
    }
    
    private func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        let iconName = UIImage(named: imageName)
        return iconName!
    }
    
    func showError(title: String, message: String) {
        errorHandling.showError(title, message: message)
    }
}

protocol ErrorHandlingDelegate {
    func showError(title: String, message: String)
}
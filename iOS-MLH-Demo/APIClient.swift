//
//  APIClient.swift
//  iOS-MLH-Demo
//
//  Created by Kyle on 10/10/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import Foundation
import Alamofire

/*
    Alamofire Documentation:
        http://cocoadocs.org/docsets/Alamofire/2.0.2/
*/

class APIClient {
    static let sharedInstance = APIClient()
    private let apiKey = "20a8ff96be15eeb6dc52262cda087da9" // TODO: Get your own API key: https://developer.forecast.io/
    
    private init() {
        // NOTE: Singleton pattern.
    }
    
    func getWeatherData(lat: String, lon: String, onCompletion: (NSDictionary)->Void) {
        let requestURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/\(lat),\(lon)")!
        Alamofire.request(.GET, requestURL).responseJSON { (_, _, data) in
            let dataValue = data.value
            
            if dataValue != nil {
                let jsonDictionary = dataValue as! NSDictionary
                onCompletion(jsonDictionary)
            }
        }
    }
}
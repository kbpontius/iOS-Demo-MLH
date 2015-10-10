//
//  ViewController.swift
//  iOS-MLH-Demo
//
//  Created by Kyle on 10/10/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class StormyViewController: UIViewController, ErrorHandlingDelegate, LocationDelegate {
    // MARK: - IBOUTLETS
    @IBOutlet weak var imgStatusImage: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPrecipChance: UILabel!
    
    // MARK: - MEMBER PROPERTIES
    private var locator: Locator?
    private var model: Model?
    private let client = APIClient.sharedInstance // This is a singleton.
    private let progressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        setupModel()
        setupLocator()
        setupLoadingSpinner()
    }
    
    // MARK: SETUP METHODS
    private func setupLocator() {
        locator = Locator(errorHandlingDelegate: self, locationDelegate: self)
        locator!.getLocation()
    }
    
    private func setupModel() {
        model = Model(errorHandlerDelegate: self)
    }
    
    private func setupLoadingSpinner() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Loading..."
    }
    
    // MARK: - Delegate Callback Methods
    func receivedLocation(location: CLLocationCoordinate2D) {
        // The completion trailing closure is an asynchronous callback.
        client.getWeatherData(location.latitude.description, lon: location.longitude.description, onCompletion: { data in
            self.model!.parseWeatherInformation(data["currently"] as! NSDictionary)
            self.imgStatusImage.image = self.model!.icon!
            self.lblStatus.text = self.model!.currentStatus
            self.lblCurrentTemp.text = self.model!.currentTemp
            self.lblHumidity.text = self.model!.currentHumidity
            self.lblPrecipChance.text = self.model!.currentChanceRain
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: nil)
    }
}

protocol LocationDelegate {
    func receivedLocation(location: CLLocationCoordinate2D)
}
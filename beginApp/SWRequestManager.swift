//
//  SWRequestManager.swift
//  beginApp
//
//  Created by Kévin Depuydt on 11/12/2016.
//  Copyright © 2016 Kévin Depuydt. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

// Request Manager to make HTPP Calls to weather server

typealias WeatherObject = Dictionary<String, AnyObject>
typealias WeatherArray = Array<WeatherObject>

class SWRequestmanager: NSObject, CLLocationManagerDelegate {
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override init() {
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location

            let latStr = String(currentLocation.coordinate.latitude)
            let longStr = String(currentLocation.coordinate.longitude)
            
            print("Location Success \(latStr)  \(longStr)/")
            
            self.actualCoordinate = (latitude: latStr, longitude: longStr)
            super.init()
        }else{
            print("Location Error set coord manually")
            self.actualCoordinate = (latitude: "48.8839", longitude: "2.3509")
            super.init()
        }
        
    }
    
    static let sharedInstance = SWRequestmanager()
    
    private let host = "https://api.darksky.net/forecast/"
    private let apiKey = "50b12c653b3c32bcf2b0debe5e5aa969"
    
    public var actualCoordinate : (latitude: String, longitude: String)

    func fetchWeather(onSuccess success: @escaping (WeatherArray) -> Void, onError error : @escaping (String) ->Void) {
        
        var strRequest = "\(host)\(apiKey)/"
        strRequest += "\(actualCoordinate.latitude),\(actualCoordinate.longitude)"
        strRequest += "?lang=fr&units=si"
    Alamofire.request(strRequest).responseJSON { response in
    
    guard let JSON = response.result.value as? Dictionary<String, Any> else{
        error("No Data")
        return
    }
        guard let daily = JSON["daily"] as? Dictionary<String, Any>, let data = daily["data"] as? Array<Dictionary<String, Any>> else {
            error("Request Manager -> \(strRequest)")
            return
        }
        success(data as WeatherArray)
        }
    }
}

//
//  DetailViewController.swift
//  beginApp
//
//  Created by Kévin Depuydt on 11/12/2016.
//  Copyright © 2016 Kévin Depuydt. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController{
    @IBOutlet var LabelDetail: UILabel!
    @IBOutlet var WeatherImage: UIImageView!
    @IBOutlet var LabelTemperature: UILabel!
    @IBOutlet var LabelPrecip: UILabel!
    @IBOutlet var LabelHotTime: UILabel!
    @IBOutlet var LabelColdTime: UILabel!
    @IBOutlet var LabelCloudCover: UILabel!
    @IBOutlet var LabelHumidity: UILabel!
    @IBOutlet var LabelWindSpeed: UILabel!
    @IBOutlet var LabelSunsetTime: UILabel!
    @IBOutlet var LabelSunriseTime: UILabel!
    
    var resultWeather : WeatherObject?
    
    let identifier = "SegueDetail"
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_3.jpeg")!)
        super.viewDidLoad()
        
        // temperature time format
        let hourFormatter = DateFormatter()
        hourFormatter.locale = Locale(identifier: "fr_FR")
        hourFormatter.dateFormat = "HH'h'"
        
        // sun time format
        let sunTimeFormatter = DateFormatter()
        sunTimeFormatter.locale = Locale(identifier: "fr_FR")
        sunTimeFormatter.dateFormat = "HH'h'mm"
        
        let tempMax = Int(round(Double(resultWeather!["temperatureMax"]! as! NSNumber)))
        let tempMaxTime = hourFormatter.string(from: NSDate(timeIntervalSince1970: resultWeather!["temperatureMaxTime"]! as! TimeInterval) as Date)
        let tempMin = Int(round(Double(resultWeather!["temperatureMin"]! as! NSNumber)))
        let tempMinTime = hourFormatter.string(from: NSDate(timeIntervalSince1970: resultWeather!["temperatureMinTime"]! as! TimeInterval) as Date)
        let precip = Int(Double(resultWeather!["precipProbability"]! as! NSNumber) * 100)
        let cloudCover = Int(Double(resultWeather!["cloudCover"]! as! NSNumber) * 100)
        let humidity = Int(Double(resultWeather!["humidity"]! as! NSNumber) * 100)
        let windSpeed = resultWeather!["windSpeed"]!
        let sunsetTime = sunTimeFormatter.string(from: NSDate(timeIntervalSince1970: resultWeather!["sunsetTime"]! as! TimeInterval) as Date)
        let sunriseTime = sunTimeFormatter.string(from: NSDate(timeIntervalSince1970: resultWeather!["sunriseTime"]! as! TimeInterval) as Date)
        
        LabelTemperature.text = "\(tempMin)°C - \(tempMax)°C"
        LabelPrecip.text = "Risque de précipitation : \(precip)%"
        LabelDetail.text = resultWeather?["summary"] as? String
        LabelHotTime.text = "Moment le plus chaud : \(tempMaxTime)"
        LabelColdTime.text = "Moment le plus froid : \(tempMinTime)"
        LabelCloudCover.text = "Couverture nuageuse : \(cloudCover)%"
        LabelHumidity.text = "Taux d'humidité : \(humidity)%"
        LabelWindSpeed.text = "Vent : \(windSpeed)mph"
        LabelSunsetTime.text = "Couché du soleil à \(sunsetTime)"
        LabelSunriseTime.text = "Levé du soleil à \(sunriseTime)"
        
        let urlimage = ViewController.downloadImage(weath: resultWeather!["icon"] as! String)
        WeatherImage.af_setImage(withURL: urlimage)
    }
    
    override func viewDidLayoutSubviews() {
        return
    }
    
}

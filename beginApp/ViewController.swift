//
//  ViewController.swift
//  beginApp
//
//  Created by Kévin Depuydt on 11/12/2016.
//  Copyright © 2016 Kévin Depuydt. All rights reserved.
//

import UIKit
import Foundation
import AlamofireImage

class ViewController: UITableViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var resultWeather : WeatherArray?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        SWRequestmanager.sharedInstance.fetchWeather(onSuccess: {(result) in
            self.resultWeather = result
            self.reload()
        }) {(error) in
            print("Error refresh => \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh(){
        self.reload()
    }
    
    func reload() {
        self.tableView.reloadData()
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return resultWeather?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RootWeatherCell.identifier) as? RootWeatherCell else {
            return UITableViewCell()
        }
            
        guard let objWeather = self.resultWeather?[indexPath.row] ,
        let summary = objWeather["summary"] as? String,
        let time = objWeather["time"] as? Int else {
            return cell
        }
            
        let tempImageView = UIImageView(image: UIImage(named: "bg_4.jpeg"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
            
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE dd MMM"
        let finaleDate = formatter.string(from: date as Date)
            
        let urlimage = ViewController.downloadImage(weath: objWeather["icon"] as! String)
            
        cell.titleLabel.text = "\(finaleDate)"
        cell.detailLabel.text = "\(summary)"
            
        cell.titleLabel.textColor = UIColor.white
        cell.detailLabel.textColor = UIColor.white
            
        cell.weatherImage.af_setImage(withURL: urlimage)

        return cell
    }
    
   static func downloadImage(weath: String) -> URL {
        print("Image index to dl \(weath)")
        let dictionnaryWeather = ["rain" : "http://icon-park.com/imagefiles/simple_weather_icons_rain-200x200.png",
                                  "wind" : "http://ian.umces.edu/imagelibrary/albums/userpics/10020/normal_ian-symbol-weather-wind-03.png",
                                  "partly-cloudy-day":"http://icon-park.com/imagefiles/simple_weather_icons_partly_cloudy-200x200.png",
                                  "partly-cloudy-night":"http://icon-park.com/imagefiles/simple_weather_icons_cloudy_night-200x200.png",
                                  "clear-day":"http://icon-park.com/imagefiles/simple_weather_icons_sunny-200x200.png",
                                  "clear-night":"http://icon-park.com/imagefiles/simple_weather_icons_night-200x200.png"]
        for (clef, valeur) in dictionnaryWeather{
            if clef == weath{
                return URL(string: valeur)!
            }
            
        }
        return URL(string: "test")!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowWeather = resultWeather?[indexPath.row]
        let destinationVC = DetailViewController()
        destinationVC.resultWeather = selectedRowWeather
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            vc.resultWeather = selectedRowWeather
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func userTapped() {
        self.performSegue(withIdentifier: "SegueDetail", sender: nil)
    }
}
    

    




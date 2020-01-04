//
//  ViewController.swift
//  WeatherApp
//
//  Created by inlineboss on 04.01.2020.
//  Copyright © 2020 inlineboss. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelseLikeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var animIndicatorManager : AnimationIndicatorManager!
    
    lazy var weatherManager = APIWeatherManager(apiKey: "276d8ce1b5c2dd8da4de8959e810947d")
    
    let coordinates = Coordinates(long:38.076752  , lat: 55.632095)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animIndicatorManager = AnimationIndicatorManager(activityIndicator)
        getCurrentWeather()
        
    }
    
    func getCurrentWeather() {
        sleep(2)
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            switch result {
            case .Success(let currentWeather):
                self.updateInfo(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                print (error.localizedDescription)
            }
        }
    }
    
    func updateInfo (currentWeather : CurrentWeather) {
        imageView.image = currentWeather.image
        pressureLabel.text = "\(Int(currentWeather.pressure * 0.750062) )mm"
        humidityLabel.text = "\(Int(currentWeather.humidity * 100) )%"
        temperatureLabel.text = "\(Int(5/9 * (currentWeather.temperature - 32) ))˚C"
        feelseLikeLabel.text = "Feels like: \(Int(5/9 * (currentWeather.apparentTemperature - 32)))˚C"
    }

    @IBAction func refresh() {
        animIndicatorManager.waiting(startBloack: {
            self.pressureLabel.isHidden = true
            self.humidityLabel.isHidden = true
        }, endBlock: {
            self.pressureLabel.isHidden = false
            self.humidityLabel.isHidden = false
        }) {
            self.getCurrentWeather()
        }
            
    }
    
}


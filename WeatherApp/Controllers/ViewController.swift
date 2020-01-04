//
//  ViewController.swift
//  WeatherApp
//
//  Created by inlineboss on 04.01.2020.
//  Copyright © 2020 inlineboss. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelseLikeLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var animIndicatorManager : AnimationIndicatorManager!
    
    var locationManger = CLLocationManager()
    
    lazy var weatherManager = APIWeatherManager(apiKey: "276d8ce1b5c2dd8da4de8959e810947d")
    
    var coordinates = Coordinates(long:38.076752  , lat: 55.632095)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestAlwaysAuthorization()
        locationManger.startUpdatingLocation()
        
        animIndicatorManager = AnimationIndicatorManager(activityIndicator)
        getCurrentWeather()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        coordinates.long = userLocation.coordinate.longitude
        coordinates.lat = userLocation.coordinate.latitude
        updateUserInterface ()
    }
    
    func getCurrentWeather() {
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

    func updateUserInterface () {
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
    
    @IBAction func refresh() {
            updateUserInterface ()
    }
    
}


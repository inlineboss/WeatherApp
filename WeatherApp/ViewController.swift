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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = WeatherManager.clearDay.image else { return }
        
        let weather = CurrentWeather(temperature: 30, appearentTemperature: 31, humidity: 600, pressure: 30, image: image)
        
        updateInfo(currentWeather: weather)
    }
    
    func updateInfo (currentWeather : CurrentWeather) {
        imageView.image = currentWeather.image
        pressureLabel.text = "\(Int(currentWeather.pressure))mm"
        humidityLabel.text = "\(Int(currentWeather.humidity))%"
        temperatureLabel.text = "\(Int(currentWeather.temperature))˚C"
        feelseLikeLabel.text = "\(Int(currentWeather.appearentTemperature))˚C"
    }

    @IBAction func refresh() {
         
    }
    
}


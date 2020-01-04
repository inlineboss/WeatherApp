import UIKit

struct CurrentWeather {
    var temperature : Double
    var apparentTemperature : Double
    var humidity : Double
    var pressure : Double
    var image : UIImage
}

extension CurrentWeather : JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard
            let temperature = JSON["temperature"] as? Double,
            let apparentTemperature = JSON["apparentTemperature"] as? Double,
            let humidity = JSON["humidity"] as? Double,
            let pressure = JSON["pressure"] as? Double,
            let icon = JSON["icon"] as? String
        else {
            return nil
        }
        
        self.image = WeatherIconManager(rawValue: icon).image!
        self.humidity = humidity
        self.pressure = pressure
        self.apparentTemperature = apparentTemperature
        self.temperature = temperature
    }
    
    
}

import UIKit

enum WeatherManager : String {
    case NaN = "NaN"
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case raine = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case tornado = "tornado"
    
    init(rawValue : String) {
        
        switch rawValue {
        case "clear-day":
            self = .clearDay
        case "clear-night":
            self = .clearNight
        case "rain":
            self = .raine
        case "snow":
            self = .snow
        case "sleet":
            self = .sleet
        case "wind":
            self = .wind
        case "fog":
            self = .fog
        case "cloudy":
            self = .cloudy
        case "partly-cloudy-day":
            self = .partlyCloudyDay
        case "partly-cloudy-night":
            self = .partlyCloudyNight
        case "hail":
            self = .hail
        case "thunderstorm":
            self = .thunderstorm
        case "tornado":
            self = .tornado
        default:
            self = .NaN
        }
    }
}

extension WeatherManager {
    var image : UIImage? {
        return UIImage(named: self.rawValue)
    }
}

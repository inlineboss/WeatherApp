import Foundation

struct Coordinates {
    let long : Double
    let lat : Double
}

enum ForecastType : FinaleURLPoint {
    var baseURL: URL {
        get {
            return URL(string: "https://api.darksky.net")!
        }
    }
    
    var path: String {
        get {
            switch self {
            case .Current(let apiKey, let coordinates):
                return "/forecast/\(apiKey)/\(coordinates.lat),\(coordinates.long)"
            }
        }
    }
    
    var request: URLRequest {
        get {
            let url = URL(string: path, relativeTo: baseURL)
            return URLRequest(url: url!)
        }
    }
    
    case Current (apiKey: String , coordinates : Coordinates)
    
    
}


final class APIWeatherManager : APIManager {
    var sessionConfiguration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey : String
    
    init(sessionConfiguration : URLSessionConfiguration, apiKey : String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: .default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinates: Coordinates, completion : @escaping (APIResult<CurrentWeather>) -> Void ) {
        let request = ForecastType.Current(apiKey: apiKey, coordinates: coordinates).request
        
        self.fetch(request: request, parse: { (json) -> CurrentWeather? in
            
            if let dictionary = json?["currently"] as? [String:AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
            
        }, completionHandler: completion)
    }
    
}



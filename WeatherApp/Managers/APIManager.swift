import UIKit

enum APIResult<T> {
    case Success (T)
    case Failure (Error)
}

protocol JSONDecodable {
    init?(JSON:[String: AnyObject])
}

protocol FinaleURLPoint {
    var baseURL : URL { get }
    
    var path : String { get }
    
    var request : URLRequest { get }
}

protocol APIManager {
    typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void
    
    var sessionConfiguration : URLSessionConfiguration { get }
    var session : URLSession { get }
    func JSONTaskWith(request: URLRequest, completion : @escaping JSONCompletionHandler ) -> URLSessionDataTask
    func fetch<T: JSONDecodable> (request : URLRequest, parse : @escaping ([String : AnyObject]? ) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    
    func JSONTaskWith(request: URLRequest, completion : @escaping JSONCompletionHandler ) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTPResponse", comment: "")]
                
                let error = NSError(domain: ManagerError.NetworkingDomain, code: ManagerError.MissingHTTPResponse, userInfo: userInfo)
                
                completion(nil,nil,error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
                        
                        completion(json, HTTPResponse, nil)
                        
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                    default:
                        print("Что-то пошло не так. Неизвестен код ответа");
                }
            }
            
        }

        return dataTask
    }
    
    func fetch<T> (request : URLRequest, parse : @escaping ([String : AnyObject]? ) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        
        let jsonTask = self.JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    
                    if let error = error {
                        
                        completionHandler(.Failure(error))
                        
                    }
                    
                    return
                    
                }
                
                if let value = parse(json) {
                    
                    completionHandler(.Success(value))
                    
                } else {
                    
                    let error = NSError(domain: ManagerError.NetworkingDomain, code: ManagerError.UnxepctedResponseErorr, userInfo: nil)
                    
                    completionHandler(.Failure(error))
                }
                
            }
        }
        
        jsonTask.resume()
    }
    
}

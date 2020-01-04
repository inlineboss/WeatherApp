import UIKit

class AnimationIndicatorManager {
    
    weak var indicator: UIActivityIndicatorView!
    
    let queue = DispatchQueue.global(qos: .utility)
    
    init(_ object: UIActivityIndicatorView!){
        indicator = object
    }
    
    func waiting (clouser : @escaping ()->()) {
     DispatchQueue.main.async {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
        queue.async {
            clouser()
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            }
        }
    }
    
    func waiting (startBloack : @escaping ()->(), endBlock : @escaping ()->(), clouser : @escaping ()->()) {
     DispatchQueue.main.async {
        startBloack()
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }
        queue.async {
            clouser()
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
                endBlock()
            }
        }
    }
    
}

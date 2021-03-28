
import UIKit
import Kingfisher
public extension UIImageView {
    
    func verifyUrl(url : String) -> Bool {
        
        if let url = NSURL(string: url) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func setImage(url: String?, placeholder: UIImage? = nil, isActivity: Bool? = false, activityColor: UIColor? = .white,completion: @escaping () -> Void) {
        
        if let urlImg = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if(verifyUrl(url: urlImg)) {
                if isActivity! {
                    self.kf.indicatorType = .activity
                    (self.kf.indicator?.view as? UIActivityIndicatorView)?.color = activityColor
                }
                
                let resource = ImageResource(downloadURL: URL.init(string: urlImg)!)
                self.kf.setImage(with: resource,
                                 placeholder: placeholder,
                                 //options: [.cacheMemoryOnly,.transition(.fade(0))],
                        options: [.transition(.fade(0))],
                                 progressBlock: { (receivedSize, totalSize) in
                    
                }) { (complete) in
                    self.backgroundColor = UIColor.clear
                    //self.image = self.image?.flipIfNeeded()
                    completion()
                    
                }
            }
            
        } else {
            self.image = placeholder
        }
    }
    

}


//
//  UIImageView+Extension.swift
//  Diwan
//
//  Created by Muzamil Hassan on 12/06/2020.
//  Copyright © 2020 Ingic. All rights reserved.
//

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
           // self.sd_setImage(with: URL(string: u), placeholderImage: placeholder)
            
           // imageView.kf.indicatorType = .activity
          //  (imageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
           // [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired),.loadDiskFileSynchronously]
            
            
            if(verifyUrl(url: urlImg)) {
           // if(urlImg.verifyUrl()) {
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
    
    func setImageNamePlaceholder(url: String?, placeholder: UIImage? = nil) {
        if let urlImg = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if(verifyUrl(url: urlImg)) {
            //if (urlImg.verifyUrl()) {
                
                let resource = ImageResource(downloadURL: URL.init(string: urlImg)!)
                self.kf.setImage(with: resource,
                                 placeholder: placeholder,
                                 //options: [.cacheMemoryOnly,.transition(.fade(1))],
                                options: [.transition(.fade(1))],
                                 progressBlock: { (receivedSize, totalSize) in
                    
                }) { (complete) in}
            }
            
        }
    }
    func setImageNamePlaceholderCircular(url: String?, placeholder: UIImage? = nil) {
        if let urlImg = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if(verifyUrl(url: urlImg)) {
            //if (urlImg.verifyUrl()) {
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                let resource = ImageResource(downloadURL: URL.init(string: urlImg)!)
                self.kf.setImage(with: resource,
                                 placeholder: placeholder,
                                 //options: [.cacheMemoryOnly,.transition(.fade(0.5))],
                                options: [.transition(.fade(0.5))],
                                 progressBlock: { (receivedSize, totalSize) in
                    
                }) { (complete) in
                    
                }
            }
        }
    }

}


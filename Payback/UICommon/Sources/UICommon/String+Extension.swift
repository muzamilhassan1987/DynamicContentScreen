//
//  File.swift
//  
//
//  Created by Systems Limited on 28/03/2021.
//

import UIKit
public extension String {
    func toFormatedDateString(_ format : String = "dd MMM yyyy") -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
           dateFormatter.locale = Locale(identifier:"en")
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            //--ww dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: self) ?? Date()
            dateFormatter.dateFormat = format
           dateFormatter.locale =  Locale(identifier:"en")
            return dateFormatter.string(from: date)
        }
        
        
        func toDateString(_ format : String = "dd MMM yyyy", dateFormat : String = "yyyy-MM-dd hh:mm:ss") -> String{
           
            var dateStr = self
            if let dotRange = self.range(of: ".") {
              dateStr.removeSubrange(dotRange.lowerBound..<self.endIndex)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier:"en")
            dateFormatter.dateFormat = dateFormat
            //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            //--ww dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: dateStr) ?? Date()
            dateFormatter.locale = Locale(identifier:"en")
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
       
        
    func toDateWithOutGMT(toFormat : String = "yyyy-MM-dd", fromFormat : String = "yyyy-MM-dd" ) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: self)
        return date
        
    }
        
}

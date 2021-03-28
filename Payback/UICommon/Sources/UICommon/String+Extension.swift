
import UIKit
public extension String {
        
    func toDateWithOutGMT(toFormat : String = "yyyy-MM-dd", fromFormat : String = "yyyy-MM-dd" ) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = toFormat
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
        
}

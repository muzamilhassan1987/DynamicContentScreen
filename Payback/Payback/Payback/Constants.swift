

import Foundation
import RealmSwift

public enum Constants {
    static let realm = try! Realm()
}



public enum DateFormatType {
    static let defaultDisplayFormat : String = "dd, MMM yyyy"
    static let reviewDisplayFormat : String = "MMMM dd, yyyy"
    static let defaultDate : String = "yyyy-MM-dd"
    static let slashFormat : String = "dd/MM/yyyy"
    static let onlyYear : String = "yyyy"
    static let serverFormatMilliSecond : String = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let serverFormat : String = "EEEE, dd LLL yyyy HH:mm:ss zzz"
}
public enum UserDefaultKey {
    static let lastUpdated = "lastUpdated"
}


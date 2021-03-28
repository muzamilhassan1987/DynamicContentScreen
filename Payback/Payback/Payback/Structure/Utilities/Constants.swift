

import Foundation
import RealmSwift

enum Constants {
   
    static let realm = try! Realm()

}

enum DateFormatType {
   
    static let serverFormat : String = "EEEE, dd LLL yyyy HH:mm:ss zzz"

}

enum UserDefaultKey {
   
    static let lastUpdated = "lastUpdated"

}

enum ContentType : String {

    case image = "image"
    case video = "video"
    case webseite = "website"
    case shoppingList = "shopping_list"

}


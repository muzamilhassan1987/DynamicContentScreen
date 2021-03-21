//
//  ShopModel.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import Foundation
import RealmSwift
class Tile : Object, Codable {

//    var name : String?
//    var headline : String?
//    var subline : String?
//    var data : String?
//    var score : Int?
//    var shoppingItems : [String]?
    
    @objc dynamic var name : String?
    @objc dynamic var headline : String?
    @objc dynamic var subline : String?
    @objc dynamic var data : String?
    @objc dynamic var score : Int = 0
    //var shoppingItems : [String]?
    let shoppingItems = List<String>()
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case headline = "headline"
        case subline = "subline"
        case data = "data"
        case score = "score"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        headline = try values.decodeIfPresent(String.self, forKey: .headline)
        subline = try values.decodeIfPresent(String.self, forKey: .subline)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        score = try values.decodeIfPresent(Int.self, forKey: .score) ?? Int()
        if let type = name {
            if (ContentType.shoppingList == ContentType(rawValue: type)) {
                //shoppingItems = [String]()
            }
        }
    }

}
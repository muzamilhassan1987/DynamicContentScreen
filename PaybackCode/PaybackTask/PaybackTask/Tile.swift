//
//  ShopModel.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import Foundation
class Tile : Codable {

    var name : String?
    var headline : String?
    var subline : String?
    var data : String?
    var score : Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case headline = "headline"
        case subline = "subline"
        case data = "data"
        case score = "score"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        headline = try values.decodeIfPresent(String.self, forKey: .headline)
        subline = try values.decodeIfPresent(String.self, forKey: .subline)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        score = try values.decodeIfPresent(Int.self, forKey: .score) ?? Int()
    }

}

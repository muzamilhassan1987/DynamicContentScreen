//
//  ShopModel.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import Foundation
class TilesResponseModel : Codable {

    var tiles: [Tile]?

    enum CodingKeys: String, CodingKey {
        case tiles = "tiles"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tiles = try values.decodeIfPresent([Tile].self, forKey: .tiles)
    }

}

//
//  ShopModel.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import Foundation
import RealmSwift
class TilesResponseModel : Object, Codable {

    //var tiles: [Tile]?
    let tiles = List<Tile>()
    enum CodingKeys: String, CodingKey {
        case tiles = "tiles"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let tilesList = try values.decodeIfPresent([Tile].self, forKey: .tiles)
        if let tiles = tilesList {
            self.tiles.append(objectsIn: tiles)
        }
        
        //tiles = try values.decodeIfPresent([Tile].self, forKey: .tiles)
    }

}

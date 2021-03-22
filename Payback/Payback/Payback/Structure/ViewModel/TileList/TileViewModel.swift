//
//  TileViewModel.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Foundation
import UIKit
import Combine
import RealmSwift
struct TileViewModel {
    
    let name : String
    let headline : String
    let subline : String
    let data : String
    let score : Int
    let shoppingItems : List<String>
    
    init(name: String, headline: String, subline: String, data: String , score: Int,shoppingItems : List<String> ) {
        self.name = name
        self.headline = headline
        self.subline = subline
        self.data = data
        self.score = score
        self.shoppingItems = shoppingItems
    }
}

extension TileViewModel: Hashable {
    static func == (lhs: TileViewModel, rhs: TileViewModel) -> Bool {
        return lhs.score == rhs.score
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(score)
    }
}

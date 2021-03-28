
import Foundation
import UIKit
import Combine
import RealmSwift

class TileViewModel {
    
    let name : String
    
    let headline : String
    
    let subline : String
    
    let data : String
    
    var imgThumb : UIImage?
    
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

extension TileViewModel {
    
    func addShoppingItem(_ message: String) {
        
        try!  Constants.realm.write() {
            
            self.shoppingItems.append(message)
            
        }
        
    }
}

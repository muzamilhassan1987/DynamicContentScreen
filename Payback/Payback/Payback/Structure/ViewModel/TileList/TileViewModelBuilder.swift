

import Foundation
import Combine

struct TileViewModelBuilder {
    static func viewModel(from tile: Tile) -> TileViewModel {
        
        return TileViewModel(name: tile.name ?? "",
                             headline: tile.headline ?? "",
                             subline: tile.subline ?? "",
                             data: tile.data ?? "",
                             score: tile.score,
                             shoppingItems: tile.shoppingItems)
        
    }
}



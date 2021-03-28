
import Combine
import RealmSwift

struct TileListViewModelInput {

    let appear: AnyPublisher<Void, Never>
   
    let search: AnyPublisher<Void, Never>
    
    let selection: AnyPublisher<TileViewModel, Never>

}

enum TileListState {
   
    case idle
    case loading
    case success(List<Tile>)
    case noResults
    case failure(Error)

}

extension TileListState: Equatable {
   
    static func == (lhs: TileListState, rhs: TileListState) -> Bool {
        
        switch (lhs, rhs) {
        
        case (.idle, .idle): return true
            
        case (.loading, .loading): return true
            
        case (.success(let lhsTiles), .success(let rhsTiles)): return lhsTiles == rhsTiles
            
        case (.noResults, .noResults): return true
            
        case (.failure, .failure): return true
            
        default: return false
            
        }
        
    }
    
}

typealias TileListViewModelOuput = AnyPublisher<TileListState, Never>

protocol TileListViewModelType {
    
    func transform(input: TileListViewModelInput) -> TileListViewModelOuput
    
    func viewModelsList(from Tiles: List<Tile>) -> [TileViewModel]
    
    func rearrangeTiles(_ tiles : [TileViewModel]) -> [TileViewModel]?
    
    func writeToDatabase(list : List<Tile>)
    
    func isRefreshData() -> Bool
    
    func fetchFromDatabase() -> List<Tile>
    
}

extension TileListViewModelType {
    
    func rearrangeTiles(_ tiles : [TileViewModel]) -> [TileViewModel]? { return nil }
    
    func writeToDatabase(list : List<Tile>) { }
    
    func isRefreshData() -> Bool { return true }
   
    func fetchFromDatabase() -> List<Tile> { return List<Tile>() }
}


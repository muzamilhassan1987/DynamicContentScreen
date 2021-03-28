
import Foundation
import Combine
import UIKit.UIImage
import Network
import RealmSwift
import UIKit
protocol TileUseCaseType {
    /// Runs Tiles search with a query string
    func getTiles() -> AnyPublisher<Result<List<Tile>, Error>, Never>
    
}

class TileUseCase: TileUseCaseType {
    
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getTiles() -> AnyPublisher<Result<List<Tile>, Error>, Never> {
        
        return networkService
            .load(Resource<TilesResponseModel>.tiles())
            .map({ (result: Result<TilesResponseModel, NetworkError>) -> Result<List<Tile>, Error> in
                
                print(result)
                
                switch result {
                
                case .success(let tilesList):
                    
                    do {
                        return .success(tilesList.tiles)
                        
                    }
                    
                case .failure(let error): return .failure(error)
                    
                }
                
            })
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
}

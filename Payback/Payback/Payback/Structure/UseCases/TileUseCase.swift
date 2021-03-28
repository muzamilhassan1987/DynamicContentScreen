
import Foundation
import Combine
import UIKit.UIImage
import Network
import RealmSwift
import UIKit
protocol TileUseCaseType {
    /// Runs Tiles search with a query string
    func getTiles() -> AnyPublisher<Result<List<Tile>, Error>, Never>

    /// Fetches details for Tile with specified id
    //func TileDetails(with id: Int) -> AnyPublisher<Result<Tile, Error>, Never>

}

final class TileUseCase: TileUseCaseType {

    private let networkService: NetworkServiceType
//    private let imageLoaderService: ImageLoaderServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
       // self.imageLoaderService = imageLoaderService
    }

    func getTiles() -> AnyPublisher<Result<List<Tile>, Error>, Never> {
        
        return networkService
            .load(Resource<TilesResponseModel>.tiles())
            .map({ (result: Result<TilesResponseModel, NetworkError>) -> Result<List<Tile>, Error> in
                print(result)
                switch result {
                case .success(let tilesList):
                    do {
                        print(tilesList)
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

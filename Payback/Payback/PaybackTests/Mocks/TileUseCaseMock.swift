
import Combine
import RealmSwift
@testable import Payback

final class TileUseCaseMock: TileUseCaseType {
    
    struct MockError: Error {}
    
    var fetchTilesResult: AnyPublisher<Result<List<Tile>, Error>, Never> = .just(.failure(MockError()))
    
    func getTiles() -> AnyPublisher<Result<List<Tile>, Error>, Never> {
        
        return fetchTilesResult
        
    }
}


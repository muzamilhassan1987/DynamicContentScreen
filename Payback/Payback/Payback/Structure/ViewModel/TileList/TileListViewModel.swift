//
//  TileListViewModel.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit
import Combine
import RealmSwift
final class TileListViewModel: TileListViewModelType {

    private weak var navigator: TileListNavigator?
    private let useCase: TileUseCaseType
    private var cancellables: [AnyCancellable] = []

    
    init(useCase: TileUseCaseType, navigator: TileListNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    init(useCase: TileUseCaseType) {
        self.useCase = useCase
        
    }

    func transform(input: TileListViewModelInput) -> TileListViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        input.selection
            .sink(receiveValue: { [unowned self] _ in self.navigator?.showDetails() })
            .store(in: &cancellables)
        let TileDetails = input.appear
            .flatMapLatest({[unowned self]  in self.useCase.getTiles() })
           // .flatMapLatest({[unowned self]  in self.useCase.getTiles() })
            .map({ result -> TileListState in
                switch result {
                case .success(List<Tile>()): return .noResults
                case .success(let Tiles): return .success(Tiles)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: TileListViewModelOuput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, TileDetails).removeDuplicates().eraseToAnyPublisher()
    }

    func viewModelsList(from Tiles: List<Tile>) -> [TileViewModel] {
        return Tiles.map({ Tile in
            return TileViewModelBuilder.viewModel(from: Tile)
        })
    }
    func rearrangeTiles(_ tiles : [TileViewModel]) -> [TileViewModel]? {
        
        return tiles.sorted(by: { $0.score > $1.score })
        
        
    }
    
    func isRefreshData() -> Bool {
        guard  let serverDate = UserDefaults.standard.string(forKey: UserDefaultKey.lastUpdated)?.toDateWithOutGMT(toFormat: DateFormatType.serverFormat) else {
            return true
        }
        let currentDate = Date()
        guard let days = NSCalendar.current.dateComponents([.day], from: currentDate, to: serverDate).day else {
            return true
        }
        return days != 0 ? true : false
    }
    
    func writeToDatabase(list : List<Tile>) {
        
            try!  Constants.realm.write()  {
                Constants.realm.deleteAll()
            }
          try!  Constants.realm.write() {
            Constants.realm.add(list)
            }
        
    }
    
    func fetchFromDatabase() -> List<Tile> {
        
        do {
            let tiles = Constants.realm.list(Tile.self)
            return tiles
        }
        
    }
}





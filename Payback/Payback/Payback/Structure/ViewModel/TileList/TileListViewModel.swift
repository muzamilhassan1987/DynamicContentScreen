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
            .flatMapLatest({self.useCase.getTiles() })
           // .flatMapLatest({[unowned self]  in self.useCase.getTiles() })
            .map({ result -> TileListState in
                switch result {
                case .success(List<Tile>()): return .noResults
//                case .success(let Tiles): return .success(self.viewModels(from: Tiles))
                case .success(let Tiles): return .success(Tiles)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: TileListViewModelOuput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        return Publishers.Merge(loading, TileDetails).removeDuplicates().eraseToAnyPublisher()
    }

    private func viewModels(from Tiles: List<Tile>) -> [TileViewModel] {
        return Tiles.map({[unowned self] Tile in
            return TileViewModelBuilder.viewModel(from: Tile)
        })
    }

}

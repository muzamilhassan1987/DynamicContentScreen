//
//  TileListViewModelType.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import Combine
import RealmSwift
struct TileListViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let search: AnyPublisher<Void, Never>
    let selection: AnyPublisher<Void, Never>
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
}


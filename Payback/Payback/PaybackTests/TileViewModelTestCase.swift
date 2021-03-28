//
//  TileViewModelTestCase.swift
//  PaybackTests
//
//  Created by Systems Limited on 29/03/2021.
//

import Combine
import XCTest
import RealmSwift
@testable import Payback

final class TileViewModelTestCase: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func testViewModel_shouldHaveValidData() throws {
        
        let viewModel = makeTileViewModel()
        
        let isRefreshData = false
        
        XCTAssertEqual(isRefreshData, viewModel.isRefreshData())
        
        XCTAssertNotNil(viewModel.fetchFromDatabase(), "List is not nil")
    
    }
    
    func testViewDidLoad_whenFetchingSuccessful_shouldHaveShowState() throws {
        
        let useCase = TileUseCaseMock()
        
        let viewModel = makeTileViewModel(tileUseCase: useCase)
        
        let tile = makeTile()
        
        let list = List<Tile>()
        
        list.append(tile)
        
        useCase.fetchTilesResult = .just(.success(list))
        
        var isShowStateTriggered = false
        
        let appear = PassthroughSubject<Void, Never>()
        
        let selection = PassthroughSubject<TileViewModel, Never>()
        
        let search = PassthroughSubject<Void, Never>()
        
        let input = TileListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                           search: search.eraseToAnyPublisher(),
                                           selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: { state in
            
            guard case .success = state else { return }
            isShowStateTriggered =  true
            
        }).store(in: &cancellables)
        
        appear.send()
       
        XCTAssertTrue(isShowStateTriggered)
       
    }
    
    func testViewDidLoad_whenFetchingDataEmpty_shouldHaveErrorState() throws {
        
        let viewModel = makeTileViewModel()
       
        var isErrorStateTriggered = false
        
        let appear = PassthroughSubject<Void, Never>()
        
        let selection = PassthroughSubject<TileViewModel, Never>()
        
        let search = PassthroughSubject<Void, Never>()
        
        let input = TileListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                           search: search.eraseToAnyPublisher(),
                                           selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: { state in
            
            guard case .failure( _) = state else { return }
            isErrorStateTriggered =  true
            
        }).store(in: &cancellables)
        
        appear.send()
        
        XCTAssertTrue(isErrorStateTriggered)
       
    }
    
}

extension TileViewModelTestCase {
    
    func makeTileViewModel(tileUseCase: TileUseCaseType = TileUseCaseMock()) -> TileListViewModel {
    
        let viewModel = TileListViewModel(useCase: tileUseCase)
        
        return viewModel
    
    }
    
    func makeTile(name: String = "test",
                  headline: String = "test",
                  subline: String = "test",
                  data: String = "test" ,
                  score: Int = 1,
                  shoppingItems : List<String> = List<String>()) -> Tile {
        
        let tile = Tile()
        
        tile.name = name
        
        tile.headline = headline
        
        tile.subline = subline
        
        tile.data = data
        
        tile.score = score
        
        tile.shoppingItems = shoppingItems
        
        return tile
    }
}

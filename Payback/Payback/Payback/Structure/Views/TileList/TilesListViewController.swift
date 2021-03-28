//
//  TilesListViewController.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import UIKit
import RealmSwift
import Combine
import SafariServices
import AVKit
import AVFoundation

class TilesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: TileListViewModelType?
    
    private let appear = PassthroughSubject<Void, Never>()
    
    private let selection = PassthroughSubject<TileViewModel, Never>()
    
    private let search = PassthroughSubject<Void, Never>()
    
    private lazy var dataSource = makeDataSource()
    
    private var cancellables: [AnyCancellable] = []
    
    private var tilesList : [TileViewModel]?
    
    var filteredTiles: [TileViewModel] = []
    
    var model : TilesResponseModel?
    
    func initialize(viewModel: TileListViewModelType) {
        
        self.viewModel = viewModel
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureUI()
        
        bind(to: viewModel!)
        
        if self.viewModel!.isRefreshData() {
            appear.send()
        }
        
        else {
            
            showListItem(tiles: self.viewModel?.fetchFromDatabase() ?? List<Tile>())
            
        }
        
    }
    
    private func configureUI() {
        
        definesPresentationContext = true
        
        title = "TILE LIST"
        
        ProgressHUD.fontStatus = .systemFont(ofSize: 15)
        
        ProgressHUD.animationType = .circleStrokeSpin
        
        ProgressHUD.colorAnimation = .systemBlue
        
        tableView.dataSource = dataSource
        
    }
    private func bind(to viewModel: TileListViewModelType) {
        
        cancellables.forEach { $0.cancel() }
        
        cancellables.removeAll()
        
        let input = TileListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                           search: search.eraseToAnyPublisher(),
                                           selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            
            self.render(state)
            
        }).store(in: &cancellables)
    }
    
    private func render(_ state: TileListState) {
        
        switch state {
        
        case .idle:
            update(with: [], animate: true)
            
        case .loading:
            ProgressHUD.show("Loading...")
            update(with: [], animate: true)
            
        case .noResults:
            ProgressHUD.dismiss()
            update(with: [], animate: true)
            
        case .failure:
            ProgressHUD.dismiss()
            update(with: [], animate: true)
            
        case .success(let tiles):
            ProgressHUD.dismiss()
            self.viewModel?.writeToDatabase(list: tiles)
            showListItem(tiles: tiles)
            
        }
    }
    
    func showListItem(tiles : List<Tile>) {
        
        tilesList = self.viewModel?.viewModelsList(from: tiles)
        
        filteredTiles = self.viewModel?.rearrangeTiles(tilesList!) ?? []
        
        update(with: filteredTiles, animate: true)
        
    }
    
}

fileprivate extension TilesListViewController {
    enum Section: CaseIterable {
        case tiles
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, TileViewModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: {  tableView, indexPath, tileViewModel in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TileTableViewCell.identifier()) as? TileTableViewCell
                else {
                    
                    assertionFailure("Failed to dequeue \(TileTableViewCell.self)!")
                    
                    return UITableViewCell()
                    
                }
                
                cell.bind(to: tileViewModel)
                
                cell.shoppingItemAdd = {[weak self](model) in
                    
                    self?.updateShoppingItem(indexPath: indexPath)
                    
                }
                
                cell.setThumbImage = {[weak self](model) in
                    
                    self?.updateThumImage(indexPath: indexPath, model: model)
                    
                }
                
                return cell
            }
        )
    }
    
    func update(with tiles: [TileViewModel], animate: Bool = true) {
        
        DispatchQueue.main.async {
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, TileViewModel>()
            
            snapshot.appendSections(Section.allCases)
            
            snapshot.appendItems(tiles, toSection: .tiles)
            
            self.dataSource.apply(snapshot, animatingDifferences: animate)
            
        }
        
    }
    
    func updateShoppingItem(indexPath : IndexPath) {
        
        DispatchQueue.main.async {
            
            let item = self.dataSource.itemIdentifier(for: indexPath)!
            
            var snapshot = self.dataSource.snapshot()
            
            snapshot.reloadItems([item])
            
            self.dataSource.apply(snapshot)
            
        }
        
    }
    
    
    func updateThumImage(indexPath : IndexPath, model : TileViewModel) {
        
        DispatchQueue.main.async {
            
            let item = self.dataSource.itemIdentifier(for: indexPath)!
            
            var snapshot = self.dataSource.snapshot()
            
            snapshot.reloadItems([item])
            
            self.dataSource.apply(snapshot)
            
        }
        
    }
    
}

extension TilesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snapshot = dataSource.snapshot()
        
        selection.send(snapshot.itemIdentifiers[indexPath.row])
    }
    
}

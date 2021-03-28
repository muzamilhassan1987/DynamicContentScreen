//
//  ShoppingListViewController.swift
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

class ShoppingListViewController: UIViewController {

    private var viewModel: TileListViewModelType?
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<Void, Never>()
    private lazy var dataSource = makeDataSource()
    private var cancellables: [AnyCancellable] = []
    private var tilesList : [TileViewModel]?
    var filteredTiles: [TileViewModel] = []
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var model : TilesResponseModel?
   // var filteredTiles: [Tile] = []
   // var filteredTiles = List<Tile>()
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
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

fileprivate extension ShoppingListViewController {
    enum Section: CaseIterable {
        case tiles
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, TileViewModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: {  tableView, indexPath, tileViewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TileTableViewCell.identifier()) as? TileTableViewCell
                 //guard let cell = tableView.dequeueReusableCell(withClass: VehicleCell.self)
                 else {
                    assertionFailure("Failed to dequeue \(TileTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: tileViewModel)
                cell.shoppingItemAdd = {[weak self](model) in
                    self?.updateCell(indexPath: indexPath)
                  //  self?.tableView.reloadRows(at: [indexPath], with: .none)
                }
                return cell
            }
        )
    }

    func update(with vehicles: [TileViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, TileViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(vehicles, toSection: .tiles)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
    func updateCell(indexPath : IndexPath) {
        DispatchQueue.main.async {
            
            let item = self.dataSource.itemIdentifier(for: indexPath)!
            var snapshot = self.dataSource.snapshot()
                snapshot.reloadItems([item])
            self.dataSource.apply(snapshot)
            
        }
    }
    
    func showTutorial() {
        if let url = URL(string: "https://www.google.com") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    func playVideo() {
        let player = AVPlayer(url: URL(string: "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
}
extension ShoppingListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let snapshot = dataSource.snapshot()
//        //selection.send(snapshot.itemIdentifiers[indexPath.row].id)
//        tableView.deselectRow(at: indexPath, animated: true)
        //showTutorial()
        playVideo()
    }

}

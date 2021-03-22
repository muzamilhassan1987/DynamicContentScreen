//
//  ShoppingListViewController.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import UIKit
import RealmSwift
import Combine


class ShoppingListViewController: UIViewController {

    private var viewModel: TileListViewModelType?
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<Void, Never>()
    private lazy var dataSource = makeDataSource()
    private var cancellables: [AnyCancellable] = []
    private var tilesList : [TileViewModel]?
    var filteredTiles: [TileViewModel] = []
    
    
    static let realm = try! Realm()
    
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
    
//    init(viewModel: TileListViewModelType) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("Not supported!")
//    }

    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel!)
        appear.send()
    }
    
    private func configureUI() {
        definesPresentationContext = true
        title = "TILE LIST"
        
        ProgressHUD.fontStatus = .systemFont(ofSize: 15)
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .systemBlue
    
    //    tableView.register(VehicleCell.nib(), forCellReuseIdentifier: VehicleCell.identifier())
        tableView.dataSource = dataSource
        
//        model = loadJsonFile()
//
//        if let tiles = model?.tiles {
//            filteredTiles.append(contentsOf: tiles)
//        }
//
//       rearrangeTiles()
//        realmWrite()
//        initializeSearchBar()
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
            tilesList = self.viewModels(from: tiles)
            filteredTiles.append(contentsOf: tilesList!)
            rearrangeTiles()
            realmWrite(list: tiles)
            update(with: filteredTiles, animate: true)
        }
    }
    private func viewModels(from Tiles: List<Tile>) -> [TileViewModel] {
        return Tiles.map({[unowned self] Tile in
            return TileViewModelBuilder.viewModel(from: Tile)
        })
    }
    
    func realmWrite(list : List<Tile>) {
        try!  ShoppingListViewController.realm.write()  {
            ShoppingListViewController.realm.deleteAll()
        }
      try!  ShoppingListViewController.realm.write() {
        ShoppingListViewController.realm.add(list)
        }
    }

    func rearrangeTiles() {
      
        filteredTiles = filteredTiles.sorted(by: { $0.score > $1.score })
        
        tableView.reloadData()
    }
    
    func initializeSearchBar() {
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Items"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
   
    func filterContentForSearchText(_ searchText: String) {
        
        if let tile = tilesList {
            if (searchText.count > 0) {
                filteredTiles = tile.filter { (tile: TileViewModel) -> Bool in
                    return (tile.name.lowercased().contains(searchText.lowercased()) ?? false)
                }
            }
            else {
                filteredTiles = Array(tile)
            }
        }
        rearrangeTiles()
    }

}
//extension ShoppingListViewController : UITableViewDelegate, UITableViewDataSource {
//
//    // number of rows in table view
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
////            if isFiltering {
////                return filteredTiles.count
////              }
////
//            return filteredTiles.count
//
//        }
//
//        // create a cell for each table view row
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//            // create a new cell if needed or reuse an old one
//            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TileTableViewCell") as! TileTableViewCell
//            let data = filteredTiles[indexPath.row]
//            cell.tileModel = data
//            cell.shoppingItemAdd = {[weak self](item) in
//
//                self?.tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            //cell.contentView.backgroundColor = .random()
//            return cell
//
//
//        }
//
//        // method to run when table view cell is tapped
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            print("You tapped cell number \(indexPath.row).")
//
//            let data = filteredTiles[indexPath.row]
//            if let type = data.name {
//                switch ContentType(rawValue: type) {
//                case .image:
//                    break
//                case .video:
//                    break
//                case .webseite:
//                    break
//                case .shoppingList:
//                    break
//                case .none:
//                    break
//                }
//            }
//
//        }
//
//}
func loadJsonFile() -> TilesResponseModel?{
    
    let jsonString = """
    {
        "tiles": [
            {
                "name": "image",
                "headline": "Tim Cook sjkfj kjfdkjfkd jkfdjkf kjdfkjfkj kjfdkjkdf jkj Tim Cook sjkfj kjfdkjfkd jkfdjkf kjdfkjfkj kjfdkjkdf jkj",
                "subline": "CEO of Apple Inc.",
                "data": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jpg",
                "score": 100
            },
            {
                "name": "video",
                "headline": "Cartoon",
                "data": "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
                "score": 10
            },
            {
                "name": "website",
                "headline": "PAYBACK",
                "subline": "Coupons, Payment and more.",
                "data": "https://www.payback.de",
                "score": 3
            },
            {
                "name": "image",
                "headline": "Swift",
                "subline": "An advanced programming language",
                "data": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Swift_logo_with_text.svg/200px-Swift_logo_with_text.svg.png",
                "score": 50
            },
            {
                "name": "website",
                "headline": "Google",
                "data": "https://www.google.de",
                "score": 30
            },
            {
                "name": "image",
                "headline": "iPhone",
                "data": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/IPhone_11_Pro_Max_Midnight_Green.svg/150px-IPhone_11_Pro_Max_Midnight_Green.svg.png",
                "score": 70
            },
            {
                "name": "website",
                "headline": "Wikipedia",
                "data": "https://www.wikimedia.org",
                "score": 4
            },
            {
                "name": "shopping_list",
                "headline": "Shopping List",
                "score": 23
            },
            {
                "name": "shopping_list",
                "headline": "Shopping List",
                "score": 71
            },
            {
                "name": "shopping_list",
                "headline": "Shopping List",
                "score": 12
            }
        ]
    }
    """
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()

    do {
        let people = try decoder.decode(TilesResponseModel.self, from: jsonData)
        print(people)
        return people
    } catch {
        print(error.localizedDescription)
    }
    return nil
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension ShoppingListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)

    
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
}

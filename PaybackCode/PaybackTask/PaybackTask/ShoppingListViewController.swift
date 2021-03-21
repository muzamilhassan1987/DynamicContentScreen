//
//  ShoppingListViewController.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var model : TilesResponseModel?
    var filteredTiles: [Tile] = []
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "SHOPPING LIST"
        
        model = loadJsonFile()
        
        if let tiles = model?.tiles {
            filteredTiles.append(contentsOf: tiles)
        }
        
        rearrangeTiles()
        
        initializeSearchBar()
    }
    

    func rearrangeTiles() {
      
        filteredTiles = filteredTiles.sorted(by: { $0.score! > $1.score! })
        
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
        
        if let tile = model?.tiles {
            if (searchText.count > 0) {
                filteredTiles = tile.filter { (tile: Tile) -> Bool in
                    return (tile.name?.lowercased().contains(searchText.lowercased()) ?? false)
                }
            }
            else {
                filteredTiles = tile
            }
        }
        rearrangeTiles()
    }

}
extension ShoppingListViewController : UITableViewDelegate, UITableViewDataSource {
    
    // number of rows in table view
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
//            if isFiltering {
//                return filteredTiles.count
//              }
//                
            return filteredTiles.count
            
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // create a new cell if needed or reuse an old one
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TileTableViewCell") as! TileTableViewCell
            let data = filteredTiles[indexPath.row]
            cell.tileModel = data
            cell.contentView.backgroundColor = .random()
            return cell
            
            
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
}
func loadJsonFile() -> TilesResponseModel?{
    
    let jsonString = """
    {
        "tiles": [
            {
                "name": "image",
                "headline": "Tim Cook",
                "subline": "CEO of Apple Inc.",
                "data": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tim_Cook_2009_cropped.jpg/220px-Tim_Cook_2009_cropped.jpg",
                "score": 1
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

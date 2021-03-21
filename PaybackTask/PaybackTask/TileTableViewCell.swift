//
//  TileTableViewCell.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import UIKit

enum ContentType : String {
    case image = "image"
    case vide = "video"
    case webseite = "website"
    case shoppingList = "shopping_list"
}

class TileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblHeadLine: UILabel!
    @IBOutlet weak var lblSubLine: UILabel!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    var tileModel : Tile? {
        didSet {
            setData()
          }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData() {
         
        lblName.text = ""
        lblHeadLine.text = ""
        lblSubLine.text = ""
        if let tile = tileModel {
            lblName.text = tile.name
            lblHeadLine.text = tile.headline
            lblSubLine.text = tile.subline
        }
    }
    func setContentType() {
        
        if let type = tileModel?.name {
            switch ContentType(rawValue: type) {
            case .image:
                break
            case .vide:
                break
            case .webseite:
                break
            case .shoppingList:
                break
            case .none:
                break
            }
        }
    }
}

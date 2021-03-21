//
//  TileTableViewCell.swift
//  PaybackTask
//
//  Created by Systems Limited on 20/03/2021.
//

import UIKit
import Kingfisher
import UICommon
import RealmSwift
enum ContentType : String {
    case image = "image"
    case video = "video"
    case webseite = "website"
    case shoppingList = "shopping_list"
}

class TileTableViewCell: UITableViewCell {

    @IBOutlet weak var viewItems: UIView!
    @IBOutlet weak var txtFieldItem: UITextField!
    @IBOutlet weak var stackViewItems: UIStackView!
    @IBOutlet weak var lblHeadLine: UILabel!
    @IBOutlet weak var lblSubLine: UILabel!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    var shoppingItemAdd : ((String) -> ())?
    var tileModel : Tile? {
        didSet {
            setData()
          }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFieldItem.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData() {
         
        stackViewItems.subviews.forEach({ $0.removeFromSuperview() })
        imgPlaceholder.image = nil
        viewItems.isHidden = true
//        lblHeadLine.isHidden = true
//        lblSubLine.isHidden = true
        if let tile = tileModel {
//            lblHeadLine.isHidden = !(tile.headline?.count ?? 0 > 0)
//            lblSubLine.isHidden = !(tile.subline?.count ?? 0 > 0)
            lblHeadLine.text = tile.headline
            lblSubLine.text = "sdmlkn k ofdof ohjfsdhofdsos hoghogho hgfoh ohfgjohgfjohfgjohjo ghjohjoghfjhgfj h"//tile.subline
            setContentType()
        }
        
    }
    
    func setContentType() {
        
        if let type = tileModel?.name {
            switch ContentType(rawValue: type) {
            case .image:
                imgPlaceholder.setImage(url: tileModel?.data, completion: {
                    
                })
                break
            case .video:
                break
            case .webseite:
                break
            case .shoppingList:
               // viewItems.isHidden = false
                setShoppingItems()
                break
            case .none:
                break
            }
        }
    }
    func setShoppingItems() {
        
        if let itemList = tileModel?.shoppingItems {
            
            for item in itemList {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: stackViewItems.frame.size.width, height: 20))
                label.text = item
                stackViewItems.addArrangedSubview(label)
            }
        }
        
        
    }
}
extension TileTableViewCell : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("END EDITING")
        //tileModel?.shoppingItems.append(textField.text!)
        addMessage(textField.text!)
        shoppingItemAdd?(textField.text!)
        textField.text = ""
        
    }
    func addMessage(_ message: String) {
        do {
            let realm = try! Realm()
            try! realm.write {
                tileModel?.shoppingItems.append(message)
            }
        } catch let error {
            print("Could not add message due to error:\n\(error)")
        }
    }
    
}

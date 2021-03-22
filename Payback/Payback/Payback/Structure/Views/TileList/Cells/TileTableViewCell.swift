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

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var viewShoppingList: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var txtFieldItem: UITextField!
    @IBOutlet weak var stackViewItems: UIStackView!
    @IBOutlet weak var lblHeadLine: UILabel!
    @IBOutlet weak var lblSubLine: UILabel!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    var shoppingItemAdd : ((TileViewModel) -> ())?
//    var tileModel : Tile? {
//        didSet {
//            setData()
//          }
//    }
    var viewModel: TileViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFieldItem.delegate = self
        viewBackground.layer.borderWidth = 2
        viewBackground.layer.borderColor = UIColor.init(red: 185/255, green: 203/255, blue: 230/255, alpha: 1.0).cgColor
        viewBackground.layer.cornerRadius = 4
    }
    
    func bind(to viewModel: TileViewModel) {
        self.viewModel = viewModel
        setData()
//        stateLabel.text = viewModel.state
//        typeLabel.text = viewModel.type
//        idLabel.text = "\(viewModel.id)"
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData() {
         
        stackViewItems.subviews.forEach({ $0.removeFromSuperview() })
        imgPlaceholder.image = nil
        lblHeadLine.isHidden = true
        lblSubLine.isHidden = true
        viewImage.isHidden = true
        viewShoppingList.isHidden = true
        if let model = viewModel {
            lblHeadLine.isHidden = !(model.headline.count > 0)
            lblSubLine.isHidden = !(model.subline.count  > 0)
            lblHeadLine.text = model.headline
            lblSubLine.text = model.subline
            setContentType()
        }
        
        
    }
    
    func setContentType() {
        
        if let type = viewModel?.name {
            switch ContentType(rawValue: type) {
            case .image:
                viewImage.isHidden = false
                imgPlaceholder.setImage(url: viewModel?.data, completion: {
                    
                })
                break
            case .video:
                viewImage.isHidden = false
                imgPlaceholder.setImage(url: viewModel?.data, completion: {
                    
                })
                break
            case .webseite:
                break
            case .shoppingList:
                
                viewShoppingList.isHidden = false
               // viewItems.isHidden = false
                setShoppingItems()
                break
            case .none:
                break
            }
        }
    }
    func setShoppingItems() {
        
        if let itemList = viewModel?.shoppingItems {
            
            for item in itemList {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: stackViewItems.frame.size.width, height: 20))
                label.numberOfLines = 0
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
        addItem(textField.text!)
        shoppingItemAdd?(viewModel!)
        textField.text = ""
        
    }
    func addItem(_ message: String) {
        do {
            let realm = try! Realm()
            try! realm.write {
                viewModel?.shoppingItems.append(message)
            }
        } catch let error {
            print("Could not add message due to error:\n\(error)")
        }
    }
    
}

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
import AVFoundation
enum ContentType : String {
    case image = "image"
    case video = "video"
    case webseite = "website"
    case shoppingList = "shopping_list"
}

class TileTableViewCell: UITableViewCell {

    @IBOutlet weak var btnPlay: UIButton!
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
        btnPlay.isHidden = true
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
                btnPlay.isHidden = false
                viewImage.isHidden = false
                self.getThumbnailImageFromVideoUrl(link: viewModel?.data ?? "") { [weak self] (thumbImage) in
                    self?.viewModel?.imgThumb = thumbImage
                    self?.imgPlaceholder.image = thumbImage
                }
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
 
    func getThumbnailImageFromVideoUrl(link: String, completion: @escaping ((_ image: UIImage?)->Void)) {
        
        guard let url = URL(string: link) else {
            return
        }
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
}

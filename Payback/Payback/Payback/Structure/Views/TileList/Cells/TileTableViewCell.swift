
import UIKit
import Kingfisher
import UICommon
import RealmSwift
import AVFoundation


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
    
    var setThumbImage : ((TileViewModel) -> ())?
    
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
                
                imgPlaceholder.setImage(url: viewModel?.data, completion: {})
                
                break
            
            case .video:
            
                btnPlay.isHidden = false
                
                viewImage.isHidden = false
                
                guard let image = self.viewModel?.imgThumb else {
                
                    self.getThumbnailImageFromVideoUrl(link: viewModel?.data ?? "") { [weak self] (thumbImage) in
                    
                        self?.viewModel?.imgThumb = thumbImage
                        
                        self?.setThumbImage?((self?.viewModel)!)
                        
                        self?.imgPlaceholder.image = thumbImage
                    
                    }
                    
                    return
                }
                
                self.imgPlaceholder.image = image
                
                break
            
            case .webseite:
            
                break
            case .shoppingList:
                
                viewShoppingList.isHidden = false
          
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
      
        addItem(textField.text!)
        
        shoppingItemAdd?(viewModel!)
        
        textField.text = ""
        
    }
    func addItem(_ message: String) {
        
        viewModel?.addShoppingItem(message)
    
    }
 
    func getThumbnailImageFromVideoUrl(link: String, completion: @escaping ((_ image: UIImage?)->Void)) {
        
        guard let url = URL(string: link) else {
            return
        }
        DispatchQueue.global().async {
    
            let asset = AVAsset(url: url)
            
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
               
                let thumbImage = UIImage(cgImage: cgThumbImage)
                
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
               
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}

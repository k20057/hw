//
//  TableViewCell.swift
//  hw
//
//  Created by  明智 on 2021/3/23.
//

import UIKit

protocol ClickTableViewCellDelegate {
    func clickTableViewCellDidTap(_ sender: ProductTVCell, image: UIImage, data: Item?)
}


struct Product: Codable {
    var cart:[Item]
}

struct Item: Codable {
    var productId: String
    var name: String
    var image: String
    var option: String?
    var quantity :Int
    var price : Int
}

class ProductTVCell: UITableViewCell {
    
    @IBOutlet weak var productView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbOption: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    
    var imageUrl : URL? = nil
    var delegate: ClickTableViewCellDelegate?
    var data: Item? = nil {
        didSet {
            lbName.text = data?.name
            let price = NumberFormatter.localizedString(from: NSNumber(value: data!.price), number: .decimal)
            lbPrice.text = "$:\(price)"
            lbQuantity.text = "\(data!.quantity)"
            
            
            if data?.option != nil {
               lbOption.text = "選項: "+(data?.option)!
            }
            
            if let urlStr = data?.image, let url = URL(string: urlStr){
                imageUrl = url
                productView.image = nil
                
                let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                    guard let self = self else {return}
                    let response = response as! HTTPURLResponse
                    let status = response.statusCode
                    if error != nil || status != 200 {
                        print("=====ERROR=\(String(describing: error))")
                        print("-- 下載失敗, 失敗網址: \(String(describing: response.url)) ")
                        
                        return
                    }
                    
                    print("-- 下載完成, 下載網址: \(String(describing: response.url)) ")
                    if self.imageUrl == response.url {
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.productView.image = image
                            }
                        }
                    }
                  
                    //檢查讀到的圖跟目前cell有沒有同一個
                    print("下載回來的網址與要顯示的網址一樣")
                }
                task.resume()
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickButton(_ sender: Any) {
        if let image = self.productView.image  {
            delegate?.clickTableViewCellDidTap(self, image: image, data: data)
        }
    }
    
    
}

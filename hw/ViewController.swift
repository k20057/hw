//
//  ViewController.swift
//  hw
//
//  Created by  明智 on 2021/3/20.
//

import UIKit

private let reuseIdentifier = "product"
private let reuseImage = "imagedetail"

class ViewController: UIViewController, ClickTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btDiscount: UIButton!
    @IBOutlet weak var lbTotalPrice: UILabel!
    var promo: Promotion?
    var promos: [Promotion]?
    var carts: [Cart]?
    let url = "https://gist.githubusercontent.com/Gary-Pan/285e1bfc13a2118abc2579d657d610ab/raw/c255104e68add386eb834a1e79af781d30c6802a/data.json"
    var totalPrice = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let url = URL(string: url) {
            // GET
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                   
                    if let jsonData = try? JSONDecoder().decode(Product.self, from: data) {
                        self.carts = jsonData.cart
                        self.promos = jsonData.promo
                        
                        for promotion in self.promos! {
                            self.promo = promotion
                        }
                        
                        for product in self.carts! {
                            self.totalPrice += product.price
                        }
                       
                        DispatchQueue.main.async {
                            let price = NumberFormatter.localizedString(from: NSNumber(value: self.totalPrice), number: .decimal)
                            self.lbTotalPrice.text = "$:\(price)"
                            self.tableView.reloadData()

                        }

                    }
                    
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
        // Do any additional setup after loading the view.
    }
    
    func clickTableViewCellDidTap(_ sender: ProductTVCell, image: UIImage, data: Cart?) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: reuseImage) as! DetailVC
        detailVC.detailImage = image
        detailVC.detailname = data?.name
        detailVC.detailOption = data?.option
        detailVC.detailQuantity = "\(data!.quantity)"
        detailVC.detailPrice = "\(data!.price)"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func usePromotionCode(_ sender: Any) {
        let controller = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        controller.addTextField { (textField) in
           textField.placeholder = "請輸入優惠碼"
           textField.keyboardType = UIKeyboardType.phonePad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let inputPromotionCode = controller.textFields?[0].text
            self.totalPrice = 0
            var count = 0
            if inputPromotionCode == self.promo?.promoCode {
                for price in self.promo!.price {
                    self.totalPrice += price.promoPrice
                    self.carts?[count].price = price.promoPrice
                    count += 1
                }
                
                let price = NumberFormatter.localizedString(from: NSNumber(value: self.totalPrice), number: .decimal)
                self.tableView.reloadData()
                self.lbTotalPrice.text = "$:\(price)"
                
            } else {
                let falsecontroller = UIAlertController(title: "優惠碼輸入錯誤", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "確定", style: .cancel, handler: nil)
                falsecontroller.addAction(cancelAction)
                self.present(falsecontroller, animated: true, completion: nil)
            }
            
        }
        
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTVCell
        let cart = carts![indexPath.row]
        cell.data = Cart(productId: cart.productId, name: cart.name, image: cart.image, option: cart.option, quantity: cart.quantity, price: cart.price)
        cell.delegate = self
        
        return cell
    }
    
    
    
    
    
    
}

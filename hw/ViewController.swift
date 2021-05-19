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

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btDiscount: UIButton!
    @IBOutlet weak var lbTotalPrice: UILabel!
    
    var pics: [Item]? = nil
    let url = "https://gist.githubusercontent.com/Gary-Pan/285e1bfc13a2118abc2579d657d610ab/raw/c255104e68add386eb834a1e79af781d30c6802a/data.json"
    
    override func viewDidLoad() {
        var totalPrice = 0
        super.viewDidLoad()
        
        if let url = URL(string: url) {
            // GET
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else {return}
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                   
                    if let cartData = try? JSONDecoder().decode(Product.self, from: data) {
                        self.pics = cartData.cart
                        
                        for product in self.pics! {
                            totalPrice += product.price
                        }
                        
                        DispatchQueue.main.async {
                            let price = NumberFormatter.localizedString(from: NSNumber(value: totalPrice), number: .decimal)
                            self.lbTotalPrice.text = "$:\(price)"
                        }

                    }
                    
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
        // Do any additional setup after loading the view.
    }
    
    func clickTableViewCellDidTap(_ sender: ProductTVCell, image: UIImage, data: Item?) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: reuseImage) as! DetailVC
        detailVC.detailImage = image
        detailVC.detailname = data?.name
        detailVC.detailOption = data?.option
        detailVC.detailQuantity = "\(data!.quantity)"
        detailVC.detailPrice = "\(data!.price)"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductTVCell
        let pic = pics![indexPath.row]
        cell.data = Item(productId: pic.productId, name: pic.name, image: pic.image, option: pic.option, quantity: pic.quantity, price: pic.price)
        cell.delegate = self
        
        return cell
    }
    
    
    
    
    
    
}

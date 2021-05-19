//
//  DetailVC.swift
//  hw
//
//  Created by  明智 on 2021/5/18.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbOption: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!

    var detailImage: UIImage?
    var detailname: String?
    var detailPrice: String?
    var detailQuantity: String?
    var detailOption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailImageView.image = detailImage
        lbName.text = detailname
        lbPrice.text = "$:"+detailPrice!
        if detailOption != nil {
            lbOption.text = "選項: "+detailOption!
        }
        
        lbQuantity.text = "訂購數量:"+detailQuantity!
        // Do any additional setup after loading the view.
    }
    


}

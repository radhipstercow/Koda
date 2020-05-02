//
//  ShopCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/13/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import SDWebImage

class ShopCell: UITableViewCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var cityAndState: UILabel!
    
    @IBOutlet weak var storeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setShop(_ shop: Shop) {
        
        storeName.text = shop.shopName
        
        if let urlString = shop.shopImageUrl {
            
            let url = URL(string: urlString)
            
            guard url != nil else {
                // Couldn't create url object
                return
            }
            
            storeImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                self.storeImage.image = image
                
            }
        }
        
        // Extreacting city and address from address
        let splitted = shop.address!.components(separatedBy: ",")
        splitted.map{ $0.replacingOccurrences(of: " ", with: "") }
        let city = splitted[1]
        let state = splitted[2]
        
        cityAndState.text = "\(city), \(state)"
    }

}

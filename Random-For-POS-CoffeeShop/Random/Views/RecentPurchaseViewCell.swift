//
//  RecentPurchaseViewCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/11/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class RecentPurchaseViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    func setItem (_ item:PurchasedItem) {
        
        itemName.text = item.itemName
        
        if let urlString = item.itemImageUrl {
            
            let url = URL(string: urlString)
            
            guard url != nil else {
                // Couldn't create url object
                return
            }
            
            itemImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                self.itemImage.image = image
                
            }
        }
    }
}

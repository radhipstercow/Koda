//
//  FeaturedItemCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/11/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class FeaturedItemCell: UITableViewCell {

    @IBOutlet weak var featuredItemImage: UIImageView!
    
    @IBOutlet weak var featuredItemShop: UILabel!
    
    @IBOutlet weak var featuredItemName: UILabel!
    
    var item:Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFeaturedItem(_ shop: Shop?) {
        
        guard shop != nil else {
            return
        }
        
        featuredItemShop.text = shop!.shopName!
        
        GetService.getItems(shop: shop!) { (items) in
            self.item = items[0]
            
            if let urlString = self.item!.itemImageUrl {
                
                let url = URL(string: urlString)
                
                guard url != nil else {
                    // Couldn't create url object
                    return
                }
                
                self.featuredItemImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                    
                    self.featuredItemImage.image = image
                    
                }
            }
        }
        
    }

}

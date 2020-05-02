//
//  ItemCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/11/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(_ item:Item) {
        
        itemNameLabel.text = item.itemName
        
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

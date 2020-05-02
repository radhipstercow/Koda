//
//  ConsumerViewItemCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/14/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class ConsumerViewItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    var item:Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setItem(_ item:Item) {
        
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

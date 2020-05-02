//
//  ShopByRegionCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/12/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class ShopByRegionCell: UICollectionViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    
    func setRegion(region: String) {
        regionName.text = region
    }
}

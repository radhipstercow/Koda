//
//  GearCell.swift
//  Random
//
//  Created by Eisuke Tamatani on 4/20/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class GearCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(image: UIImage) {
        button.setImage(image, for: .normal)
    }

    
}

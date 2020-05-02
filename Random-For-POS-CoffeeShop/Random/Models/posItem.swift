//
//  posItem.swift
//  Random
//
//  Created by Eisuke Tamatani on 4/15/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct posItem {
    
    var itemId:String?
    var itemName:String?
    var itemImageUrl:String?
    var videoLink:String?
    var description:String?
    var amount: Int?
    var optionGroups: [DrinkOptionGroup]?
    
    init? (id: String, name:String, imageUrl: String, videoLink: String, description: String, amount: Int, options: [DrinkOptionGroup]?) {
        self.itemId = id
        self.itemName = name
        self.itemImageUrl = imageUrl
        self.videoLink = videoLink
        self.description = description
        self.amount = amount
        self.optionGroups = options
    }
}

//
//  Item.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/12/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Item {
    
    var itemId:String?
    var itemName:String?
    var itemImageUrl:String?
    var videoLink:String?
    var description:String?
    
    /// The option groups that can be used to customize the drink
    var optionGroups: [String]?
    
    init?(snapshot:DataSnapshot) {
        
        // Item data
        let itemData = snapshot.value as? [String:Any]
        
        if let itemData = itemData {
            
            let itemId = snapshot.key
            let itemName = itemData["itemName"]
            let itemImageUrl = itemData["itemImageUrl"]
            let videoLink = itemData["YTLink"]
            let description = itemData["description"]
            let options = itemData["options"]
            
            guard itemImageUrl != nil || videoLink != nil || description != nil else {
                return nil
            }
            
            self.itemId = itemId
            self.itemName = itemName as? String
            self.itemImageUrl = itemImageUrl as? String
            self.videoLink = videoLink as? String
            self.description = description as? String
            self.optionGroups = options as? [String]
        }
        
    }
}

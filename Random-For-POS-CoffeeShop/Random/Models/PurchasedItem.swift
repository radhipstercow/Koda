//
//  PurchasedItem.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/12/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PurchasedItem {
    
    var transactionId:String?
    var itemName:String?
    var itemImageUrl:String?
    var videoLink:String?
    var discription:String?

    init?(snapshot:DataSnapshot) {
        
        // Item data
        let itemData = snapshot.value as? [String:String]
        
        if let itemData = itemData {
            
            let transactionId = snapshot.key
            let itemName = itemData["itemName"]
            let itemImageUrl = itemData["itemImageUrl"]
            let videoLink = itemData["YTLink"]
            let discription = itemData["discription"]
            
            guard itemName != nil || itemImageUrl != nil || videoLink != nil || discription != nil else {
                return nil
            }
            
            self.transactionId = transactionId
            self.itemName = itemName
            self.itemImageUrl = itemImageUrl
            self.videoLink = videoLink
            self.discription = discription
            
        }
        
    }
    
}

//
//  Store.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/13/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Shop {
    
    var userId:String?
    var username:String?
    var shopName:String?
    var address:String?
    var shopImageUrl:String?
    var items:[Item]?
    
    init?(snapshot:DataSnapshot) {
        
        // Item data
        let storeData = snapshot.value as? [String:Any]
        
        if let storeData = storeData {
            
            let userId = snapshot.key
            let username = storeData["username"]
            let shopName = storeData["shopName"]
            let address = storeData["address"]
            let shopImageUrl = storeData["shopImageUrl"]
            let items = storeData["items"]
            
            guard username != nil || shopName != nil || address != nil || shopImageUrl != nil else {
                return nil
            }
            
            self.userId = userId
            self.username = username as? String
            self.shopName = shopName as? String
            self.address = address as? String
            self.shopImageUrl = shopImageUrl as? String
            self.items = items as? [Item]
            
        }
        
    }
}

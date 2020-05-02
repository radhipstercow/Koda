//
//  RetailerService.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/29/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class RetailerService {
    
    static func createProfile(userId:String, username:String, shopName:String, address:String, shopImageUrl:String, completion: @escaping (Retailer?) -> Void) -> Void {
        
        // Create a dictionary for the use profile
        let userNameData = ["username":username, "shopName":shopName, "address":address, "shopImageUrl":shopImageUrl]
        
        // Get a database reference
        let ref = Database.database().reference()
        
        // Create the profile for the user id
        ref.child("retailers").child(userId).setValue(userNameData) { (error, ref) in
        
            if error != nil {
                // There was an error
                completion(nil)
            }
            else {
                // Create the user and pass it back
                let r = Retailer()
                r.userId = userId
                r.username = username
                r.shopName = shopName
                r.address = address
                r.shopImageUrl = shopImageUrl
                
                completion(r)
            }
        }
    }
    
    static func getRetailerProfile(userId:String, completion: @escaping(Retailer?) -> Void) -> Void {
        
        // Get a database reference
        let ref = Database.database().reference()
        
        // Try to retriece the profile for the passed in userid
        ref.child("retailers").child(userId).observeSingleEvent(of: .value) { (snapshot) in
        
            // Check the returned snapshot value to see if there's a profile
            if let userProfileData = snapshot.value as? [String:Any] {
                
                // This means tehre's a profile
                // Create a photo user with the profile details
                // Pass it into the completion closire
                var r = Retailer()
                r.userId = snapshot.key
                r.username = userProfileData["username"] as? String
                r.shopName = userProfileData["shopName"] as! String
                r.address = userProfileData["address"] as! String
                r.shopImageUrl = userProfileData["shopImageUrl"] as! String
                
                // Pass it into the completion closure
                completion(r)
            }
            else {
                
                // This means there wasn't a profile
                // Return nil
                completion(nil)
            }
            
        }
    }
}

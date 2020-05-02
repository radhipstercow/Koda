//
//  ItemService.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/12/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class GetService {
    
    // Get recent purchases of the consumer user
    static func getPurcahsedItems (completion: @escaping([PurchasedItem]) -> Void ) -> Void {
        
        // Getting a reference to the database
        let dbRef = Database.database().reference()
        
        let userId = Auth.auth().currentUser!.uid
        
        // Make the db call
        dbRef.child("consumers").child(userId).child("purchasedItems").observeSingleEvent(of: .value) { (snapshot) in
            
            // Declare an array to hold the photos
            var retrieveditems = [PurchasedItem]()
            
            // Get the list of snapshots
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            
            if let snapshots = snapshots {
                
                // Loop through each snapshot and parse out the photos
                for snap in snapshots {
                    
                    // Try to create a photo from a snapshot
                    let i = PurchasedItem(snapshot: snap)
                    
                    // If successful, then add it to our array
                    if i != nil {
                        retrieveditems.insert(i!, at: 0)
                    }
                }
            }
            // After parsing the snapshots, call the completion closure
            completion(retrieveditems)
        }
    }
    
    // Get items for retailer view
    static func getItems(completion: @escaping([Item]) -> Void ) -> Void {
        
        // Getting a reference to the database
        let dbRef = Database.database().reference()
        
        let userId = Auth.auth().currentUser!.uid
        
        // Make the db call
        dbRef.child("retailers").child(userId).child("items").observeSingleEvent(of: .value) { (snapshot) in
            
            // Declare an array to hold the photos
            var retrieveditems = [Item]()
            
            // Get the list of snapshots
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            
            if let snapshots = snapshots {
                
                // Loop through each snapshot and parse out the photos
                for snap in snapshots {
                    
                    // Try to create a photo from a snapshot
                    let i = Item(snapshot: snap)
                    
                    // If successful, then add it to our array
                    if i != nil {
                        retrieveditems.insert(i!, at: 0)
                    }
                    
                }
                
            }
            
            // After parsing the snapshots, call the completion closure
            completion(retrieveditems)
        }
    }
    
    // Get items for consumers view
    static func getItems(shop: Shop, completion: @escaping([Item]) -> Void ) -> Void {
        
        // Getting a reference to the database
        let dbRef = Database.database().reference()
        
        let userId = shop.userId!
        
        // Make the db call
        dbRef.child("retailers").child(userId).child("items").observeSingleEvent(of: .value) { (snapshot) in
            
            // Declare an array to hold the photos
            var retrieveditems = [Item]()
            
            // Get the list of snapshots
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            
            if let snapshots = snapshots {
                
                // Loop through each snapshot and parse out the photos
                for snap in snapshots {
                    
                    // Try to create a photo from a snapshot
                    let i = Item(snapshot: snap)
                    
                    // If successful, then add it to our array
                    if i != nil {
                        retrieveditems.insert(i!, at: 0)
                    }
                    
                }
                
            }
            
            // After parsing the snapshots, call the completion closure
            completion(retrieveditems)
        }
    }
    
    static func getShops(completion: @escaping([Shop]) -> Void ) -> Void {
        
        // Getting a reference to the database
        let dbRef = Database.database().reference()
        

        // Make the db call
        dbRef.child("retailers").observeSingleEvent(of: .value) { (snapshot) in
            
            // Declare an array to hold the photos
            var retrievedStores = [Shop]()
            
            // Get the list of snapshots
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            
            if let snapshots = snapshots {
                
                // Loop through each snapshot and parse out the photos
                for snap in snapshots {
                    
                    // Try to create a shop from a snapshot
                    let s = Shop(snapshot: snap)
                    
                    // If successful, then add it to our array
                    if s != nil {
                        retrievedStores.insert(s!, at: 0)
                    }
                    
                }
                
            }
            
            // After parsing the snapshots, call the completion closure
            completion(retrievedStores)
        }
    }
}

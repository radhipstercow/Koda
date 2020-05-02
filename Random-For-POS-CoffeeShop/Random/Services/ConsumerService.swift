//
//  ConsumerService.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/28/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ConsumerService {
    
    static func createUserProfile(userId:String, username:String, completion: @escaping (Consumer?) -> Void) -> Void {
        
        // Create a dictionary for the use profile
        let userNameData = ["username":username]
        
        
        // Get a database reference
        let ref = Database.database().reference()
        
        // Create the profile for the user id
        ref.child("consumers").child(userId).setValue(userNameData) { (error, ref) in
        
            if error != nil {
                // There was an error
                completion(nil)
            }
            else {
                // Create the user and pass it back
                let c = Consumer(userId: userId, username: username)
                completion(c)
            }
        }
    }
    
    static func getConsumerProfile(userId:String, completion: @escaping(Consumer?) -> Void) -> Void {
    
        // Get a database reference
        let ref = Database.database().reference()
        
        // Try to retriece the profile for the passed in userid
        ref.child("consumers").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            
            // Check the returned snapshot value to see if there's a profile
            if let userProfileData = snapshot.value as? [String:Any] {
                
                // This means tehre's a profile
                // Create a photo user with the profile details
                // Pass it into the completion closire
                var c = Consumer()
                c.userId = snapshot.key
                c.username = userProfileData["username"] as? String
                
                // Pass it into the completion closure
                completion(c)
            }
            else {
                
                // This means there wasn't a profile
                // Return nil
                completion(nil)
            }
        }
        
    }
}

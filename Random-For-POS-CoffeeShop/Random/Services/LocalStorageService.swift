//
//  LocalStorageService.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/29/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation

class LocalStorageService {
    
    static func saveConsumer(user:Consumer) {
        
        // Get standard user defaults
        let defaults = UserDefaults.standard
        
        defaults.set(user.userId, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(user.username, forKey: Constants.LocalStorage.storedUsername)
        defaults.set("consumer", forKey: "userType")
    
    }
    
    static func loadCurrentUser() -> Consumer? {
        
        // Get standard user defaults
        let defaults = UserDefaults.standard
        
        let username = defaults.value(forKey: Constants.LocalStorage.storedUsername) as? String
        let userId = defaults.value(forKey: Constants.LocalStorage.storedUserId) as? String
        
        // Couldn't get a user, return nil
        guard username != nil || userId != nil else{
            return nil
        }
        
        let c = Consumer(userId: userId!, username: username!)
        return c
        
    }
    
    static func clearCurrentUser() {
        
        // Get standard user defaults
        let defaults = UserDefaults.standard
        
        defaults.set(nil, forKey: Constants.LocalStorage.storedUsername)
        defaults.set(nil, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(nil, forKey: "userType")
        
    }
    
    static func saveRetailer(user:Retailer) {
        
        // Get standard user defaults
        let defaults = UserDefaults.standard
        
        defaults.set(user.userId, forKey: Constants.LocalStorage.storedUserId)
        defaults.set(user.username, forKey: Constants.LocalStorage.storedUsername)
        defaults.set("retailer", forKey: "userType")

    }
    
    
}

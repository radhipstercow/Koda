//
//  SettingsViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/29/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConsumerSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signoutTapped(_ sender: Any) {
        
        do {
            
            // Sign put using firebase auth methods
            try Auth.auth().signOut()
            
            // Clear local storage
            LocalStorageService.clearCurrentUser()
            
            // Change the window to show the login screen
            let loginVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController)
            
            view.window?.rootViewController = loginVC
            view.window?.makeKeyAndVisible()
            
        }
        catch {
            // Error signing out
            print("Couldn't sign out")
        }
    }
    

}

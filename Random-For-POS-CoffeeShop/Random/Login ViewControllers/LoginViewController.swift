//
//  LoginViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/27/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var consumerButton: UIButton!
    
    @IBOutlet weak var retailerButton: UIButton!
    
    @IBOutlet weak var producerButton: UIButton!
    
    var tap:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make buttons circle
        self.makeButtonCircle(consumerButton)
        self.makeButtonCircle(retailerButton)
        self.makeButtonCircle(producerButton)
        

    }
    
    // Method to make the buttons circle
    func makeButtonCircle(_ object: AnyObject) {
        
        object.layer?.cornerRadius = (object.frame?.size.width)! / 2
        object.layer?.masksToBounds = true
        
    }
    
    func doEmailAuth() {
        
        // Create a firebase auth ui object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        // Set the login view controller as the delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
            
        // Present it
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func consumerTapped(_ sender: UIButton) {
        
        tap = "consumer"
        
        doEmailAuth()
        
    }
    
    @IBAction func retailerTapped(_ sender: Any) {
        
        tap = "retailer"
        
        doEmailAuth()
        
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check if an error occured
        guard error == nil else {
            print("Error has happend")
            return
        }
        
        // Get the user
        let user = authDataResult?.user
        
        // Check if user is nil
        if let user = user {
            // This means that we have a user, now check if they have a profile
            
            
            if tap == "consumer"{
                
                ConsumerService.getConsumerProfile(userId: user.uid) { (c) in
                    
                    if c == nil {
                        // No profile, go to profile controller
                        self.performSegue(withIdentifier: Constants.Segue.consumerProfileViewController, sender: self)
                    }
                    else {
                        
                        // Save the logged in uset to local storage
                        LocalStorageService.saveConsumer(user: c!)
                        
                        // This user has a profile, to tab controller
                        let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.consumerTabBarController)
                        
                        self.view.window?.rootViewController = tabBarVC
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
            else if tap == "retailer"{
                
                RetailerService.getRetailerProfile(userId: user.uid) { (r) in
                    
                    if r == nil {
                        // No profile, go to profile controller
                        self.performSegue(withIdentifier: Constants.Segue.retailerProfileViewController, sender: self)
                    }
                    else {
                        
                        // Save the logged in uset to local storage
                        LocalStorageService.saveRetailer(user: r!)
                        
                        // This user has a profile, to tab controller
                        let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.retailerTabBarController)
                        
                        self.view.window?.rootViewController = tabBarVC
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
            
            
        }
        
    }
    
}

//
//  AppDelegate.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/27/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import Firebase
import SquareInAppPaymentsSDK
import SquarePointOfSaleSDK
import SquareInAppPaymentsSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()

        // Check local storage to see if a user is saved
        let user = LocalStorageService.loadCurrentUser()
        
        if user != nil {
            
            // Get current user type
            let userType = defaults.string(forKey: "userType")!
            
            print(userType)
            if userType == "consumer" {
                
                // Set your Square Application ID
                SQIPInAppPaymentsSDK.squareApplicationID = Constants.Square.APPLICATION_ID
                
                // Create a tab bar controller
                let tabBarVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: Constants.Storyboard.consumerTabBarController)
                
                // Show it
                window?.rootViewController = tabBarVC
                window?.makeKeyAndVisible()
                
            }
            else if userType == "retailer" {
                
                SCCAPIRequest.setClientID(SquareApplicationId)

                // Create a tab bar controller
                let tabBarVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: Constants.Storyboard.retailerTabBarController)
                
                // Show it
                window?.rootViewController = tabBarVC
                window?.makeKeyAndVisible()
                
            }
            
        }
        
        return true
    }

    /// This method is called when the Point of Sale app calls back to your app after the transaction completes or is canceled
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if let sourceApp = options[.sourceApplication] as? String, sourceApp.hasPrefix("com.squareup.square"),
            let response = try? SCCAPIResponse(responseURL: url) {

            return true
        }
        return false
    }



    // MARK: UISceneSession Lifecycle

    /* func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
 */


}


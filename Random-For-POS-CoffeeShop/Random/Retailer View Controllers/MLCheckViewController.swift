//
//  MLCheckViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/23/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class MLCheckViewController: UIViewController {
    
    var itemId: String?

    @IBOutlet weak var amountField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setAmount(amount: Int){
        
        // Create a dictionry for the item
        let itemData = ["amount":amount]
        
        // Get a database reference
        let ref = Database.database().reference()
        
        let u = Auth.auth().currentUser!
                
        // Create the profile for the user id
        ref.child("retailers").child(u.uid).child("items").child(itemId!).child("amount").setValue(itemData) { (error, ref) in
            if error != nil {
                // There was an error
                print("There was an error")
            }
            else {
                // There wasn't an error
                print("There wasn't an error")
            }
        }
    }
    
    // The method to send the item to ConsumerViewItemVC before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let imageTrainVC = segue.destination as? ImageSetViewController
        
        if let imageTrainVC = imageTrainVC {
            
            // Set the place for the detail view controller
            imageTrainVC.itemId = itemId
            imageTrainVC.userId = Auth.auth().currentUser!.uid
            
        }
    }
    
    @IBAction func noTapped(_ sender: Any) {
        if amountField.text != "" {
            let amountInt = Int(amountField.text!)
            setAmount(amount: amountInt!)
        }
        
        //Go to the tab bar controll
        let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.retailerTabBarController)

        self.view.window?.rootViewController = tabBarVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func yesTapped(_ sender: Any) {
        if amountField.text != nil {
            let amountInt = Int(amountField.text!)
            setAmount(amount: amountInt!)
        }
        
        performSegue(withIdentifier: Constants.Segue.toImageTrain, sender: self)
    }
    

}

//
//  RetailerHomeViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/4/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage
import Firebase

class RetailerHomeViewController: UIViewController {

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Item]()
    
    var posItems = [posItem]()
    
    private var appFlowController: AppFlowController?
    
    var window: UIWindow?
    
    static let size = DrinkOptionGroup(name: "Size", selectionType: .single, isRequired: true, options: [
        DrinkOption(name: "Small", price: 100),
        DrinkOption(name: "Medium", price: 200),
        DrinkOption(name: "Large", price: 300),
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RetailerService.getRetailerProfile(userId: Auth.auth().currentUser!.uid) { (r) in
            
            self.storeNameLabel.text = r?.shopName
            self.address.text = r?.address
            
            let url = URL(string: (r?.shopImageUrl!)!)
            
            self.storeImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                self.storeImage.image = image
            }
        }
        
        // Configure the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Create and add the refresh control
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Retrieve and display the photos
        GetService.getItems { (items) in
            
            self.items = items
            self.tableView.reloadData()
            
        }
        
        for item in items {
            convertItem(item: item){ (posItem) in
                if posItem != nil {
                    self.posItems.append(posItem!)
                }
            }
        }
        
    }
    
    func convertItem(item: Item, completion: @escaping(posItem?) -> Void) {

        let itemId = item.itemId
        let itemName = item.itemName
        let itemImageUrl = item.itemImageUrl
        let videoLink = item.videoLink
        let description = item.description
        
        var optionGroup = [DrinkOptionGroup]()
        let options = item.optionGroups
        if options != nil {
            for opt in options! {
                let option = getGroup(nameString: opt)
                if option != nil  {
                    optionGroup.append(option!)
                }
            }
        }
        
        var amount: Int?
        getAmount(itemId: itemId!) { (a) in
            if a != nil {
                amount = a!
            }
            if amount == nil {
                completion(nil)
            }
            else {
                completion(posItem(id: itemId!, name: itemName!, imageUrl: itemImageUrl!, videoLink: videoLink!, description: description!, amount: amount!, options: optionGroup)!)
            }
        }
        
        
    }
    
    func getAmount(itemId: String, completion: @escaping(Int?) -> Void) -> Void {
        // Get a database reference
        let ref = Database.database().reference()
        let userId = Auth.auth().currentUser!.uid
        
        var amount = Int()
        
        // Try to retriece the profile for the passed in userid
        ref.child("retailers").child(userId).child("items").child(itemId).child("amount").observeSingleEvent(of: .value) { (snapshot) in
            
            if let amountData = snapshot.value as? [String: Int] {
                amount = amountData["amount"]!
                completion(amount)
            }
            else {
                completion(nil)
            }
        }
    }
    
    // The method to send the item to ItemVC before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemVC = segue.destination as? ItemViewController
        
        if let itemVC = itemVC {
            
            // Set the place for the detail view controller
            itemVC.item = items[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    func getGroup(nameString: String) -> DrinkOptionGroup? {
        
        var optionGroups = [DrinkOptionGroup]()
        let size = DrinkOptionGroup(name: "size", selectionType: .single, isRequired: true, options: [
            DrinkOption(name: "Small", price: 100),
            DrinkOption(name: "Medium", price: 200),
            DrinkOption(name: "Large", price: 300),
        ])
        optionGroups.append(size)
        
        for optionsGroup in optionGroups {
            if optionsGroup.name == nameString {
                return optionsGroup
            }
        }
        
        return nil
    }
    
    func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshInitiated(refechControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func refreshInitiated(refechControl:UIRefreshControl) {
        
        // Call the photo service retrieve photos
        GetService.getItems { (items) in
            
            self.items = items
            self.tableView.reloadData()
            refechControl.endRefreshing()
        }
        
    }
    
    @IBAction func POSTapped(_ sender: Any) {
        self.appFlowController = AppFlowController(drinks: self.posItems)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appFlowController
        window?.makeKeyAndVisible()
    }
    
}


// MARK: - Extensions
extension RetailerHomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get an item cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.itemCell, for: indexPath) as! ItemCell
        
        // Get the item for this row
        let item = items[indexPath.row]
        
        // Set the details for the cell
        cell.setItem(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.toItemView, sender: self)
    }
    
    
}

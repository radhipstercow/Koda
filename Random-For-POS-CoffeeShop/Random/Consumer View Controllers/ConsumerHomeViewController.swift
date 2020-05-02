//
//  ConsumerHomeViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/13/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ConsumerHomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var shops = [Shop]()
    
    var purchasedItems = [PurchasedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Create and add the refresh control
        addRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Retrieve and display the photos
        GetService.getShops { (shops) in
            self.shops = shops
            self.tableView.reloadData()
        }
        
        // Retrieve and display the photos of recently purchased items
        GetService.getPurcahsedItems { (items) in
            self.purchasedItems = items
            self.collectionView.reloadData()
        }
        
    }
    
    // The method to send the shop info to shopinfoVC before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shopInfoVC = segue.destination as? ShopInfoViewController
        
        if let shopInfoVC = shopInfoVC {
            
            // Set the place for the detail view controller
            shopInfoVC.shop = shops[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshInitiated(refechControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        collectionView.addSubview(refreshControl)
        
    }
    
    @objc func refreshInitiated(refechControl:UIRefreshControl) {
        
        // Call the photo service retrieve photos
        GetService.getShops { (shops) in
            self.shops = shops
            self.tableView.reloadData()
            refechControl.endRefreshing()
        }
        
        // Call the photo service retrieve photos
        GetService.getPurcahsedItems { (items) in
            self.purchasedItems = items
            self.collectionView.reloadData()
            refechControl.endRefreshing()
        }
    }
}

// MARK: - Table View Extensions
extension ConsumerHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a photo cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.shopCell, for: indexPath) as! ShopCell
        
        // Get the photofor this row
        let shop = shops[indexPath.row]
        
        // Set the details for the cell
        cell.setShop(shop)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.toShopView, sender: self)
    }
    
}

// MARK: - Collection View Extensions
extension ConsumerHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchasedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a photo cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.recentPurchaseCell, for: indexPath) as! RecentPurchaseViewCell
        
        // Get the photofor this row
        let item = purchasedItems[indexPath.item]
        
        // Set the details for the cell
        cell.setItem(item)
        
        return cell
    }
    
    
}

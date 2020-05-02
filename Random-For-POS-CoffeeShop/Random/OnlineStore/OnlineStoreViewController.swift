//
//  OnlineStoreViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/10/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class OnlineStoreViewController: UIViewController {

    @IBOutlet weak var featuredItemImage: UIImageView!
    
    @IBOutlet weak var featuredItemShopName: UILabel!
    
    @IBOutlet weak var featuredItemName: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item:Item?
    
    var items = [Item]()
    
    var shops = [Shop]()
    
    let shopNum = 1
    let itemNum = 0
    
    let regions = ["Ethiopia", "Kenya", "Burundi", "Colombia", "Costa Rica", "Brazil"]
    
    let gears = ["griders", "brewers", "cups", "others"]
    
    @IBOutlet weak var regionCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionCollectionView.delegate = self
        regionCollectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        // Create and add the refresh control
        addRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
        // The item is randumly set at this point
        GetService.getShops { (shops) in
            self.shops = shops
            
            self.featuredItemShopName.text = self.shops[self.shopNum].shopName
            
            GetService.getItems(shop: shops[self.shopNum]) { (items) in
                
                self.items = items
                
                self.item = items[self.itemNum]
                
                self.featuredItemName.text = self.item?.itemName
                
                if let urlString = self.item?.itemImageUrl {
                    
                    let url = URL(string: urlString)
                    
                    guard url != nil else {
                        // Couldn't create url object
                        return
                    }
                    
                    self.featuredItemImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                        
                        self.featuredItemImage.image = image
                        
                    }
                }
            }
        }
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemInfoVC = segue.destination as? ConsumerViewItemViewController
        
        if let itemInfoVC = itemInfoVC {
            
            // Set the place for the detail view controller
            itemInfoVC.item = self.items[itemNum]
            
        }
    }
    
    @IBAction func featuredItemTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.toFeaturedItemInfo, sender: self)
    }

    func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshInitiated(refechControl:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
    @objc func refreshInitiated(refechControl:UIRefreshControl) {
        
        // Call the photo service retrieve photos
        GetService.getShops { (shops) in
            self.shops = shops
            self.collectionView.reloadData()
            refechControl.endRefreshing()
        }
    }

}

extension OnlineStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gears.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.gearCell, for: indexPath) as! GearCell
        
        let image = UIImage(named: "gear\(indexPath.row)")
        cell.setImage(image: image!)
        
        return cell
    }
    
}

extension OnlineStoreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a photo cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.shopByRegionCell, for: indexPath) as! ShopByRegionCell
        
        // Get the photofor this row
        let region = regions[indexPath.item]
        
        // Set the details for the cell
        cell.setRegion(region: region)
        
        return cell
    }
    
    
}


//
//  ShopInfoViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/13/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class ShopInfoViewController: UIViewController {

    @IBOutlet weak var shopName: UILabel!

    @IBOutlet weak var addressButton: UIButton!
    
    @IBOutlet weak var shopImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var shop:Shop?
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard shop != nil else {
            return
        }
        
        showShopInfo(shop!)
        
        // Configure the tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Create and add the refresh control
        addRefreshControl()
        
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Retrieve and display the photos
        GetService.getItems(shop: shop!) { (items) in
            
            self.items = items
            self.tableView.reloadData()
        }
    }
    
    // The method to send the item to ConsumerViewItemVC before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemVC = segue.destination as? ConsumerViewItemViewController
        
        if let itemVC = itemVC {
            
            // Set the place for the detail view controller
            itemVC.item = items[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    func addRefreshControl() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshInitiated(refechControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func refreshInitiated(refechControl:UIRefreshControl) {
        
        // Call the get service retrieve shop info
        GetService.getItems(shop: shop!) { (items) in
            
            self.items = items
            self.tableView.reloadData()
            refechControl.endRefreshing()
        }
        
    }

    func showShopInfo(_ s: Shop) {
        
        // Set vars
        shopName.text = s.shopName
        addressButton.setTitle(s.address, for: .normal)
        
        let url = URL(string: (s.shopImageUrl)!)
        
        self.shopImage.sd_setImage(with: url) { (image, error, cacheType, url) in
            self.shopImage.image = image
        }
    }
    
    @IBAction func addressTapped(_ sender: Any) {
        
        let mapVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mapViewController) as? MapViewController
        
        if let mapVC = mapVC {
            
            // Set the property
            mapVC.shop = shop
            
            // Present the view controller
            present(mapVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Extensions
extension ShopInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get an item cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboard.consumerViewItemCell, for: indexPath) as! ConsumerViewItemCell
        
        // Get the item for this row
        let item = items[indexPath.row]
        
        // Set the details for the cell
        cell.setItem(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.toConsumerViewItemInfo, sender: self)
    }
}

//
//  Constraints.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/27/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Segue {
        
        static let consumerProfileViewController = "goToConsumerProfile"
        static let retailerProfileViewController = "goToRetailerProfile"
        
        static let toItemView = "toItemView"
        static let toShopView = "toShopInfo"
        static let toConsumerViewItemInfo = "toConsumerViewItemInfo"
        
        static let toOnlinePay = "toOnlinePay"
        
        static let toFeaturedItemInfo = "sotreShowFeaturedItemInfo"
        
        static let toImageTrain = "toImageTrain"
        
        static let toTrainSelect = "toTrainSelect"
        
        static let scanToShow = "scanToShow"
        
    }
    
    struct LocalStorage {
        
        static let storedUsername = "storedUsername"
        static let storedUserId = "storedUserId"
        
    }
    
    struct Storyboard {
        
        static let consumerTabBarController = "ConsumerTabBarController"
        static let retailerTabBarController = "RetailerTabBarController"
        static let loginViewController = "LoginViewController"
        static let retailerHomeViewController = "RetailerHomeViewController"
        
        static let consumerViewItemCell = "ConsumerViewItemCell"
        static let itemCell = "ItemCell"
        static let shopCell = "ShopCell"
        static let featuredItemCell = "FeaturedItemCell"
        static let recentPurchaseCell = "RecentPurchaseViewCell"
        
        static let shopByRegionCell = "ShopByRegionCell"
        static let gearCell = "GearCell"
        
        static let mapViewController = "MapViewController"
        
        static let onlineStoreViewController = "OnlineStoreViewController"
        
        static let mlCheckViewController = "MLCheckViewController"
        
        static let imageSetViewController = "ImageSetViewController"
        
        static let scanedItemViewController = "ScanedItemViewController"
        
    }
    
    struct SquareStoryboard {
        
        static let onlinePayViewController = "OnlinePayViewController"
        
    }
    
    struct Square {
        
        static let APPLICATION_ID: String  = "sandbox-sq0idb-WV5JO6g7zQ-59r2UO9gF8Q"
        static let CHARGE_SERVER_HOST: String = "https://random-in-app-pay.herokuapp.com"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
        
    }
    
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "merchant.com.koda"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }
    
}

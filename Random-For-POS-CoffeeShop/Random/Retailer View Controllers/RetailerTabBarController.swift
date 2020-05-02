//
//  RetailerTabBarController.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/29/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import SquarePointOfSaleSDK

class RetailerTabBarController: UITabBarController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //ボタン押下時の呼び出しメソッド
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
        print("tapped")
    }
}

//
//  OrderNavigationController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/24/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class OrderNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
    }
}

extension OrderNavigationController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return ((viewControllers.last as? HalfSheetPresentationControllerHeightProtocol)?.halfsheetHeight ?? 0.0) + navigationBar.bounds.height
    }
}


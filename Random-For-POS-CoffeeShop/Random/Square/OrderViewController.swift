//
//  OrderViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/24/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import SquareInAppPaymentsSDK

protocol OrderViewControllerDelegate: class {
    func didRequestPayWithApplyPay()
    func didRequestPayWithCard()
}

class OrderViewController: UIViewController {
    
    weak var delegate: OrderViewControllerDelegate?
    var applePayResponse : String?
    
    var address = ""
    var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderView = OrderView()
        self.view = orderView
        
        orderView.shipAddress = address
        orderView.name = name
        
        orderView.commonInit()

        orderView.addCardButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        orderView.applePayButton.addTarget(self, action: #selector(didTapApplePayButton), for: .touchUpInside)
        orderView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
    }
    
    
    // MARK: - Button tap functions
        
        @objc private func didTapCloseButton() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc private func didTapPayButton() {
            delegate?.didRequestPayWithCard()
        }
        
        @objc private func didTapApplePayButton() {
            delegate?.didRequestPayWithApplyPay()
        }
    }

    extension OrderViewController: HalfSheetPresentationControllerHeightProtocol {
        var halfsheetHeight: CGFloat {
            return (view as! OrderView).stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        }
    

}

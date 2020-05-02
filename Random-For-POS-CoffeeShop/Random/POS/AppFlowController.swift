//
//  Copyright © 2017 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import SquarePointOfSaleSDK

/// Manages flow of screens in the app
final class AppFlowController: UIViewController, AlertShowing {
    fileprivate let drinks: [posItem]

    let editButton = UIButton(type: UIButton.ButtonType.system)
    var window: UIWindow?

    // MARK: - Init

    init(drinks: [posItem]) {
        self.drinks = drinks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("OrderFlowController must be initialized using `init(drinks:)`")
    }
    
    // MARK: - UIViewController Overrides
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDrinkSelection()
        
        makeButton()

    }
    
    func makeButton() {
        editButton.addTarget(self, action: #selector(AppFlowController.editTapped(_:)), for: .touchUpInside)
        editButton.tintColor = .black
        editButton.backgroundColor = .white
        editButton.frame = CGRect(x: 30, y: 30, width: 150, height: 50)
        editButton.setImage(#imageLiteral(resourceName: "EditButton"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.contentVerticalAlignment = .fill
        editButton.contentHorizontalAlignment = .fill
        editButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        self.view.addSubview(editButton)
    }

    
    // MARK: - Private
    
    fileprivate func showDrinkSelection() {
        let drinkSelection = SelectDrinkViewController(drinks: drinks)
        
        // SelectDrinkViewController will notify its delegate when the customer selects a drink
        drinkSelection.delegate = self
        
        addChild(drinkSelection)
        view.addSubview(drinkSelection.view)
        drinkSelection.view.frame = view.bounds
        drinkSelection.didMove(toParent: self)
    }
    
    fileprivate func showCustomization(for drink: posItem) {
        let drinkCustomization = CustomizeDrinkViewController(drink: drink)
        
        // CustomizeDrinkViewController will notify its delegate when the customer finishes customizing their drink by tapping the Check Out button, or when they cancel
        drinkCustomization.delegate = self
        present(drinkCustomization, animated: true, completion: nil)
    }
    
    fileprivate func checkOut(with order: DrinkOrder) {
        do {
            let request = try makePointOfSaleAPIRequest(for: order)
            try SCCAPIConnection.perform(request)
        }
        catch {
            restart(animated: false)
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    /// Return to the Select Drink screen so the next customer can place an order
    fileprivate func restart(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
    
    @objc func editTapped(_ sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.retailerTabBarController) as! RetailerTabBarController
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: false, completion: nil)
        
    }
}

// MARK: - Select Drink Delegate

extension AppFlowController: SelectDrinkViewControllerDelegate {
    
    func selectDrinkViewControllerDidSelect(_ drink: posItem) {
        showCustomization(for: drink)
    }
}

// MARK: - Customize Drink Delegate

extension AppFlowController: CustomizeDrinkViewControllerDelegate {
    
    func customizeDrinkViewControllerDidFinish(with order: DrinkOrder) {
        print(order)
        checkOut(with: order)
    }

    func customizeDrinkViewControllerDidCancel() {
        restart()
    }
}

// MARK: - Point of Sale API

extension AppFlowController {
    
    // This method is called from AppDelegate after the customer cancels or completes a transaction in the Point of Sale app
    func handlePointOfSaleAPIResponse(_ response: SCCAPIResponse) {
        if let error = response.error {
            handlePointOfSaleAPIError(error)
        }
        else {
            restart(animated: false)
            showAlert(withTitle: "Payment Successful!")
        }
    }
    
    private func handlePointOfSaleAPIError(_ error: Error) {
        let posAPIErrorCode = SCCAPIErrorCode(rawValue: UInt((error as NSError).code))
        
        if case .userNotActivated? = posAPIErrorCode, TenderTypes.contains(.card) {
            print("In order to accept credit cards, the account logged in to Square Point of Sale must be activated. Visit squareup.com/activate.")
        }
        
        if case .paymentCanceled? = posAPIErrorCode {
            // Log the error but allow the user to retry payment
            print("Payment canceled")
        }
        
        else {
            // Otherwise just display the error
            restart(animated: false)
            showAlert(withTitle: "Error", message: error.localizedDescription)
        }
    }
    
    fileprivate func makePointOfSaleAPIRequest(for order: DrinkOrder) throws -> SCCAPIRequest {
        let callbackURL = URL(string: CallbackURLScheme)!
        let amount = try SCCMoney(amountCents: order.price, currencyCode: CurrencyCode)
        
        return try SCCAPIRequest(callbackURL: callbackURL,
                                 amount: amount,
                                 userInfoString: nil,
                                 locationID: nil,
                                 notes: nil,
                                 customerID: nil,
                                 supportedTenderTypes: TenderTypes,
                                 clearsDefaultFees: false,
                                 returnAutomaticallyAfterPayment: true)
    }
}

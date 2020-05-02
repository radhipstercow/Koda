//
//  OnlinePayViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/24/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import SquareInAppPaymentsSDK
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

enum Result<T> {
    case success
    case failure(T)
    case canceled
}

class OnlinePayViewController: UIViewController, UITextFieldDelegate {

    fileprivate var applePayResult: Result<String> = Result.canceled
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    var item:Item?
    
    var address = ""
    
    let states = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statePicker.delegate = self
        statePicker.dataSource = self
        
        nameTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        zipTextField.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // unfocus
        textField.resignFirstResponder()
        // focus the nex tag if there is one
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    func addItemToHistory(completion: @escaping (Bool) -> Void) -> Void {
        
        guard item != nil else {
            return
        }
        
        // Get a database reference
        let ref = Database.database().reference()
        
        let u = Auth.auth().currentUser!
        
        // Create a dictionry for the item
        let itemData = ["itemName":item!.itemName,"itemImageUrl":item!.itemImageUrl, "YTLink":item!.videoLink,"description":item!.description]
        
        // Create the profile for the user id
        ref.child("consumers").child(u.uid).child("purchasedItems").childByAutoId().setValue(itemData) { (error, ref) in
            
            if error != nil {
                // There was an error
                completion(false)
            }
            else {
                // There wasn't an error
                completion(true)
            }
            
        }
    }
    
    // Generate random string for purchase items
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    private func showOrderSheet() {
        // Open the buy modal
        let orderViewController = OrderViewController()
        orderViewController.delegate = self
        let nc = OrderNavigationController(rootViewController: orderViewController)
        nc.modalPresentationStyle = .custom
        nc.transitioningDelegate = self
        
        
        orderViewController.address = address
        
        guard nameTextField.text != nil && nameTextField.text != "" else {
            print("You should type in the name")
            return
        }
        orderViewController.name = nameTextField.text!
        
        present(nc, animated: true, completion: nil)
    }
    
    private var serverHostSet: Bool {
        return Constants.Square.CHARGE_SERVER_HOST != "REPLACE_ME"
    }
    
    private var appleMerchanIdSet: Bool {
        return Constants.ApplePay.MERCHANT_IDENTIFIER != "REPLACE_ME"
    }
    

    @IBAction func continueTapped(_ sender: Any) {
        
        let street = streetTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let state = states[statePicker.selectedRow(inComponent: 0)]
        
        let zip = zipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard street != nil && street != "" && city != nil && city != "" && zip != nil && zip != "" else{
            print("Something is wrong with typed in values")
            return
        }
            
        address = "\(street!), \(city!), \(state), \(zip!)"
        
        showOrderSheet()
    }
    
}

extension OnlinePayViewController {
    func makeCardEntryViewController() -> SQIPCardEntryViewController {
        // Customize the card payment form
        let theme = SQIPTheme()
        theme.errorColor = .red
        theme.tintColor = Color.primaryAction
        theme.keyboardAppearance = .light
        theme.messageColor = Color.descriptionFont
        theme.saveButtonTitle = "Pay"

        return SQIPCardEntryViewController(theme: theme)
    }
}

// MARK: - In App API Extension
extension OnlinePayViewController: SQIPCardEntryViewControllerDelegate {
    func cardEntryViewController(_: SQIPCardEntryViewController,didCompleteWith _: SQIPCardEntryCompletionStatus) {
        // Note: If you pushed the card entry form onto an existing navigation controller,
        // use UINavigationController.popViewController(animated:) instead
        dismiss(animated: true, completion: nil)
    }

    func cardEntryViewController(_: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        
        ChargeApi.processPayment(cardDetails.nonce) {
            (transactionID, errorDescription) in

            
            guard let errorDescription = errorDescription else {
                // MARK: - No error occured, we successfully charged
                
                self.addItemToHistory() {(error) in
                    
                    // Check if the item was saved to purchasedItems
                    if !error {
                        // Error occurred in item saving
                        print("Error occured during saving the item to your history")
                        return
                    }
                    // TODO: Go to the tab bar controll
                    
                }
                
                completionHandler(nil)
                return
            }

            // Pass error description
            let error = NSError(
              domain: "com.example.supercookie",
              code: 0,
              userInfo:[NSLocalizedDescriptionKey : errorDescription])
            completionHandler(error)
        }
        
        // Send card nonce to your server to store or charge the card.
        // When a response is received, call completionHandler with `nil` for success,
        // or an error to indicate failure.

        /*
         MyAPIClient.shared.chargeCard(withNonce: cardDetails.nonce) { transaction, chargeError in

             if let chargeError = chargeError {
                 completionHandler(chargeError)
             }
             else {
                 completionHandler(nil)
             }
         }
         */

    }
}

extension OnlinePayViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - OrderViewControllerDelegate functions
extension OnlinePayViewController : OrderViewControllerDelegate {
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            let vc = self.makeCardEntryViewController()
            vc.delegate = self

            let nc = UINavigationController(rootViewController: vc)
            self.present(nc, animated: true, completion: nil)
        }
    }

    func didRequestPayWithApplyPay() {
        dismiss(animated: true) {
            self.requestApplePayAuthorization()
        }
    }

    private func didNotChargeApplePay(_ error: String) {
        // Let user know that the charge was not successful
        let alert = UIAlertController(title: "Your order was not successful",
                                      message: error,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func didChargeSuccessfully() {
        // Let user know that the charge was successful
        let alert = UIAlertController(title: "Your order was successful",
                                      message: "Go to your Square dashbord to see this order reflected in the sales tab.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCurlInformation() {
        let alert = UIAlertController(title: "Nonce generated but not charged",
                                      message: "Check your console for a CURL command to charge the nonce, or replace Constants.Square.CHARGE_SERVER_HOST with your server host.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showMerchantIdNotSet() {
        let alert = UIAlertController(title: "Missing Apple Pay Merchant ID",
                                      message: "To request an Apple Pay nonce, replace Constants.ApplePay.MERCHANT_IDENTIFIER with a Merchant ID.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension OnlinePayViewController : PKPaymentAuthorizationViewControllerDelegate {
    func requestApplePayAuthorization() {
        guard SQIPInAppPaymentsSDK.canUseApplePay else {
            return
        }

        guard appleMerchanIdSet else {
            showMerchantIdNotSet()
            return
        }

        let paymentRequest = PKPaymentRequest.squarePaymentRequest(
            merchantIdentifier: Constants.ApplePay.MERCHANT_IDENTIFIER,
            countryCode: Constants.ApplePay.COUNTRY_CODE,
            currencyCode: Constants.ApplePay.CURRENCY_CODE
        )

        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Super Cookie", amount: 1.00)
        ]

        let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)

        paymentAuthorizationViewController!.delegate = self

        present(paymentAuthorizationViewController!, animated: true, completion: nil)
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void){

        // Turn the response into a nonce, if possible
        // Nonce is used to actually charge the card on the server-side
        let nonceRequest = SQIPApplePayNonceRequest(payment: payment)

        nonceRequest.perform { [weak self] cardDetails, error in
            guard let cardDetails = cardDetails else {
                let errors = [error].compactMap { $0 }
                completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
                return
            }
            
            guard let strongSelf = self else {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: []))
                return
            }
            
            ChargeApi.processPayment(cardDetails.nonce) { (transactionId, error) in
                if let error = error, !error.isEmpty {
                    strongSelf.applePayResult = Result.failure(error)
                } else {
                    strongSelf.applePayResult = Result.success
                }

                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            }
        }
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            switch self.applePayResult {
            case .success:
                guard self.serverHostSet else {
                    self.showCurlInformation()
                    return
                }
                self.didChargeSuccessfully()
            case .failure(let description):
                self.didNotChargeApplePay(description)
                break
            case .canceled:
                self.showOrderSheet()
            }
        }
    }
}


// MARK: - UINavigationControllerDelegate

extension OnlinePayViewController: UINavigationControllerDelegate {
   func navigationControllerSupportedInterfaceOrientations(
       _: UINavigationController
   ) -> UIInterfaceOrientationMask {
       return .portrait
   }
}


// MARK: - Picker Extension
extension OnlinePayViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return states[row]
    }
    
}


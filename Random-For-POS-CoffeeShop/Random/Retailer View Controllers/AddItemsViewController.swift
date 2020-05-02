//
//  AddItemsViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/4/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import WebKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class AddItemsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
 
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var YTLinkTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var itemId:String?
    
    // Store Propoerties
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate to monitor notification
        itemNameTextField.delegate = self
        YTLinkTextField.delegate = self
        descriptionTextView.delegate = self
        
        self.descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5

        //Listen for keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    }
    
    // Extract youtube video ID from youtube links
    func extractYouTubeId(from url: String) -> String? {
        let typePattern = "(?:(?:\\.be\\/|embed\\/|v\\/|\\?v=|\\&v=|\\/videos\\/)|(?:[\\w+]+#\\w\\/\\w(?:\\/[\\w]+)?\\/\\w\\/))([\\w-_]+)"
        let regex = try? NSRegularExpression(pattern: typePattern, options: .caseInsensitive)
        return regex
            .flatMap { $0.firstMatch(in: url, range: NSMakeRange(0, url.count)) }
            .flatMap { Range($0.range(at: 1), in: url) }
            .map { String(url[$0]) }
    }
    
    //UITextFieldDelegate Method
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
    
    func saveItems(itemName:String, itemImageUrl:String, YTLink:String, discription:String, completion: @escaping (Bool) -> Void) -> Void {
        
        // Create a dictionry for the item
        let itemData = ["itemName":itemName,"itemImageUrl":itemImageUrl, "YTLink":YTLink,"description":discription, "options": ["size"] ] as [String : Any]
        
        // Get a database reference
        let ref = Database.database().reference()
        
        let u = Auth.auth().currentUser!
        
        itemId = ref.child("retailers").child(u.uid).child("items").childByAutoId().key;
        
        // Create the profile for the user id
        ref.child("retailers").child(u.uid).child("items").child(itemId!).setValue(itemData) { (error, ref) in
            
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
    
    // MARK:- Kryboard Actions
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func KeyboardWillChange(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            
            view.frame.origin.y = -keyboardRect.height / 2
            
        } else {
            view.frame.origin.y = 0
        }
    }
    
    // MARK:- Image Storage
    func saveStoreImage(image:UIImage, completion: @escaping(String) -> Void) {
        
        // Get data representation of the image
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            print("Couldn't turn the image into data")
            return
        }
        
        // Get a storage reference
        let userid = Auth.auth().currentUser!.uid
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference().child("itemImages/\(userid)/\(itemNameTextField.text)/\(filename).jpg")
        
        // Upload the photo
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                // An error during upload pccurred
            }
            else {
                // Upload was successful, now create a darabase entry
                self.createPhotoDatabaseEntry(ref: ref) { (imageUrl:String) in
                    completion(imageUrl)
                }
            }
        }
    }
    
    func createPhotoDatabaseEntry(ref:StorageReference, completion: @escaping(String) -> Void) {
        
        // Get a download url for the photo
        let imageUrl = ref.downloadURL { (url, error) in
            if error != nil {
                print("Couldn't retrieve the url")
                return
            }
            else {
                let imageUrl = url!.absoluteString
                completion(imageUrl)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let trainSelectVC = segue.destination as? MLCheckViewController
        
        if let trainSelectVC = trainSelectVC {
            
            // Set the place for the detail view controller
            trainSelectVC.itemId = itemId
            
        }
    }
    
    // MARK:- Button Actions

    @IBAction func addImageTapped(_ sender: Any) {
        
        let pickerView = UIImagePickerController()
               
        // Set cameraroll sor chooseing a photo
        // choose '.camera' if you want to take the picture
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
            
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard YTLinkTextField.text != "" && YTLinkTextField.text != nil && itemNameTextField.text != nil && itemNameTextField.text != "" && descriptionTextView.text != nil && descriptionTextView.text != "" else{
            print("Something is wrong with the value you typed in")
            return
        }
        
        // For YouTube url
        let videoUrl = extractYouTubeId(from: YTLinkTextField.text!)!
        let itemName = itemNameTextField.text!
        let discription = descriptionTextView.text!
        
        guard itemImage != nil else{
            print("couldn't get image data")
            return
        }
        
        // Save the store image to storage first, and then save the url of the image to db
        saveStoreImage(image: itemImage.image!) { (imageUrl:String) in
            
            self.saveItems(itemName: itemName, itemImageUrl: imageUrl, YTLink: videoUrl, discription: discription) { (b) in
                    
                // Check if the item was created
                if !b {
                    // Error occurred in item saving
                    return
                }
                else {
                    
                    self.performSegue(withIdentifier: Constants.Segue.toTrainSelect, sender: self)

                }
            }
        
        }
        
    }
}

//MARK:- Extensions

extension AddItemsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // method that will be called when user choose the pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get the info of photo
        let image = info[.originalImage] as! UIImage
        // show it
        itemImage.image = image
        
        // Dismiss the button
        addImageButton.alpha = 0
        
        // dismiss the photo library
        self.dismiss(animated: true)
    }
}

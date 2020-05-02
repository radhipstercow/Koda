//
//  RetailerProfileViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 1/29/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class RetailerProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var storeNameTextField: UITextField!
    
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var zipTextField: UITextField!
    
    @IBOutlet weak var storeImage: UIImageView!
        
    let states = [ "AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        statePicker.delegate = self
        statePicker.dataSource = self
    
    }
    
    
    @IBAction func uploadImageTapped(_ sender: UIButton) {
        
        let pickerView = UIImagePickerController()
        
        // Set cameraroll sor chooseing a photo
        // choose '.camera' if you want to take the picture
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        
        self.present(pickerView, animated: true, completion: nil)
    }
    
    @IBAction func startTapped(_ sender: UIButton) {
        
        // Check that there's a user logged in because we need the uid
        guard Auth.auth().currentUser != nil else {
            // No user logged in
            print("No user logged in")
            return
        }
        
        // Check that the textfield has a valid name
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let storeName = storeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let street = streetTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let state = states[statePicker.selectedRow(inComponent: 0)]
        
        let zip = zipTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard storeImage != nil else{
            print("couldn't get image data")
            return
        }
        
        // Save the store image to storage first, and then save the url of the image to db
        saveStoreImage(image: storeImage.image!) { (imageUrl:String) in
            
            print(imageUrl)
            
            guard username != nil && username != "" && storeName != nil && storeName != "" && street != nil && street != "" && city != nil && city != "" && zip != nil && zip != "" else{
                print("Something is wrong with typed in values")
                return
            }
                
            let address = "\(street!), \(city!), \(state), \(zip!)"
                
            // Call User Service to create the profile
            RetailerService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!, shopName:storeName!, address:address, shopImageUrl:imageUrl) { (r) in
                    
                // Check if the profile was created
                if r == nil {
                    // Error occurred in profile saving
                    return
                }
                else {
                    
                    // Save to local storage
                    LocalStorageService.saveRetailer(user: r!)
                                    
                    // Go to the tab bar controll
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.retailerTabBarController)
                                                      
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                }
            }
            
        }
    }
    
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
        
        let ref = Storage.storage().reference().child("shopImages/\(userid)/\(filename).jpg")

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
        
    }// End of SaveStoreImage
    
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
    
    
}

extension RetailerProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension RetailerProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // method that will be called when user choose the pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // get the info of photo
        let image = info[.originalImage] as! UIImage
        // show it
        storeImage.image = image
        
        // dismiss the photo library
        self.dismiss(animated: true)
    }
}


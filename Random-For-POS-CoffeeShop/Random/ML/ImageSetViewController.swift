//
//  ImageSetViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/23/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

import UIKit
import CoreML
import CoreImage

class ImageSetViewController: UIViewController {

    // The desired number of drawings to update the model
    private let requiredDrawingCount = 3
     
    // Collection of the training drawings
    private var trainingImages = [ImageMat]()

    // The itemId that the model should predict when passed similar images
    var itemId: String?
    var userId: String?
     
    // A Boolean that indicates whether the instance has all the required drawings.
    var isReadyForTraining: Bool { trainingImages.count == requiredDrawingCount }
    
    // Creates a batch provider of training data given the contents of `trainingDrawings`.
    var featureBatchProvider: MLBatchProvider {
        var featureProviders = [MLFeatureProvider]()

        let inputName = "drawing"
        let outputName = "label"
                 
        for image in trainingImages {
            let inputValue = image.featureValue
            let outputValue = MLFeatureValue(string: String("\(userId!),\(itemId!)"))
             
            let dataPointFeatures: [String: MLFeatureValue] = [inputName: inputValue,
                                                                outputName: outputValue]
             
            if let provider = try? MLDictionaryFeatureProvider(dictionary: dataPointFeatures) {
                featureProviders.append(provider)
            }
        }
        
        return MLArrayBatchProvider(array: featureProviders)
    }
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var thisImage:UIImageView?
    
    var featureValue: MLFeatureValue {
        // Get the model's image constraints.
        let imageConstraint = ModelUpdater.imageConstraint
        
        let imageFeatureValue = try? MLFeatureValue(cgImage: thisImage as! CGImage,
                                                    constraint: imageConstraint)
        return imageFeatureValue!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard itemId != nil || itemId != "" else {
            print("item name isn't correct")
            return
        }
    }
    
    func imagePick() {
        let pickerView = UIImagePickerController()
        
        // Set cameraroll sor chooseing a photo
        // choose '.camera' if you want to take the picture
        pickerView.delegate = self
        pickerView.sourceType = .photoLibrary
        
        self.present(pickerView, animated: true, completion: nil)
        
    }
    
    // Adds a drawing to the private array, but only if the type requires more.
    func addImage(_ image: ImageMat) {
        if trainingImages.count < requiredDrawingCount {
            trainingImages.append(image)
        }
        doneButton.isEnabled = isReadyForTraining
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        print("User tapped \"Done\"; kicking off model update...")
        
        // Convert the drawings into a batch provider as the update input.
        let imageTrainingData = self.featureBatchProvider
        
        // Update the Drawing Classifier with the drawings.
        DispatchQueue.global(qos: .userInitiated).async {
            ModelUpdater.updateWith(trainingData: imageTrainingData) {
                DispatchQueue.main.async {
                    //Go to the tab bar controll
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.retailerTabBarController)

                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                    
                }
                
                
            }
        }
    }

    @IBAction func add1Tapped(_ sender: Any) {
        thisImage = image1
        imagePick()
    }
    
    @IBAction func add2Tapped(_ sender: Any) {
        thisImage = image2
        imagePick()
    }
    
    @IBAction func add3Tapped(_ sender: Any) {
        thisImage = image3
        imagePick()
    }
    
}

extension ImageSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // method that will be called when user choose the pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard thisImage != nil else {
            return
        }
        
        // get the info of photo
        let image = info[.originalImage] as! UIImage
        // show it
        thisImage!.image = image
        
        // dismiss the photo library
        self.dismiss(animated: true)
        
        addImage(ImageMat(image: thisImage!.image!))
    }
}

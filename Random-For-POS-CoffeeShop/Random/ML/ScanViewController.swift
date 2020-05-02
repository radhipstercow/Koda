//
//  ScanViewController.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/23/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

//class ScanViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    var checkImage:ImageMat?
//
//    var image: UIImage?
//
//    var scanedItem:Item?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let ItemVC = segue.destination as? ConsumerViewItemViewController
//
//        if let ItemVC = ItemVC {
//
//            // Set the place for the detail view controller
//            ItemVC.item = self.scanedItem
//
//        }
//    }
//
//    func check() {
//
//        guard image != nil else {
//            print("Image isn't set yet")
//            return
//        }
//
//        checkImage = ImageMat(image: image!)
//
//        let imageFeatureValue = checkImage!.featureValue
//
//        // If classification is enabled, it tries to classify the drawings with the sticker classifier
//        let imageLabel = ModelUpdater.predictLabelFor(imageFeatureValue)
//
//        if let lbl = imageLabel {
//            print("Label: \(lbl)")
//        }
//        else {
//            print("Can't recognize")
//        }
//
//        // Sprit the value into userId and ItemId
//        let strArray = imageLabel!.components(separatedBy: ",")
//
//        let storeId = strArray[0]
//        print(strArray[0])
//
//        let itemId = strArray[1]
//        print(strArray[1])
//
//        let dbRef = Database.database().reference()
//
//        dbRef.child("retailers").child(storeId).child("items").observeSingleEvent(of: .value) { (snapshot) in
//
//            // Declare an array to hold the photos
//            var retrieveditems = [Item]()
//
//            // Get the list of snapshots
//            let snapshots = snapshot.children.allObjects as? [DataSnapshot]
//
//            if let snapshots = snapshots {
//
//                // Loop through each snapshot and parse out the photos
//                for snap in snapshots {
//
//                    // Try to create a photo from a snapshot
//                    let i = Item(snapshot: snap)
//
//                    // If successful, then add it to our array
//                    if i != nil {
//                        retrieveditems.insert(i!, at: 0)
//                    }
//
//                }
//
//            }
//
//            var counter = 0
//            for retrieveditem in retrieveditems {
//                if retrieveditem.itemId == itemId{
//                    self.scanedItem = retrieveditems[counter]
//
//                    print(retrieveditem.itemName!)
//                }
//                counter += 1
//            }
//
//            self.moveToItemView()
//
//        }
//
//
//    }
//
//    func moveToItemView() {
//        performSegue(withIdentifier: Constants.Segue.scanToShow, sender: self)
//    }
//
//
//    @IBAction func resetTapped(_ sender: Any) {
//        ModelUpdater.resetDrawingClassifier()
//    }
//
//    @IBAction func addTapped(_ sender: Any) {
//        let pickerView = UIImagePickerController()
//
//        // Set cameraroll sor chooseing a photo
//        // choose '.camera' if you want to take the picture
//        pickerView.delegate = self
//        pickerView.sourceType = .photoLibrary
//
//        self.present(pickerView, animated: true, completion: nil)
//    }
//
//
//
//}
//
//extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    // method that will be called when user choose the pic
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        guard imageView != nil else {
//            return
//        }
//
//        // get the info of photo
//        image = info[.originalImage] as! UIImage
//
//        // show it
//        imageView!.image = image
//
//        // dismiss the photo library
//        self.dismiss(animated: true)
//
//        check()
//    }
//}
//
//
//
//





class ScanViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // カメラ等のキャプチャに関連する入出力を管理するクラス
    var session: AVCaptureSession!
    // 写真データを取得するクラス
    var output: AVCapturePhotoOutput?
    // カメラでキャプチャした映像をプレビューするクラス
    var previewLayer: AVCaptureVideoPreviewLayer?

    //@IBOutlet weak var imageView: UIImageView!

    var image: UIImage?

    var scanedItem:Item?

    var checkImage:ImageMat?

    @IBOutlet weak var cameraView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setPreview()

    }

    override func viewDidLayoutSubviews() {
        //Set the frame of preview to make it same as cameraview
        previewLayer?.frame = cameraView.bounds
    }
    
    // Called befor the screen is loaded
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func setPreview() {
        
        // Initialize session and output
        session = AVCaptureSession()
        output = AVCapturePhotoOutput()

        // Resolution setting
        //session.sessionPreset = AVCaptureSessionPreset1920x1080
        session.sessionPreset = AVCaptureSession.Preset.hd1920x1080

        let camera = AVCaptureDevice.default(for: AVMediaType.video)

        do {
            // input camera to device
            let input = try AVCaptureDeviceInput(device: camera!)
            
            // Input
            if (session.canAddInput(input)) {
                session.addInput(input)

                // Output
                if (session.canAddOutput(output!)) {
                    session.addOutput(output!)
                    
                    // Run camera
                    session.startRunning()

                    // Generate Preview
                    previewLayer = AVCaptureVideoPreviewLayer(session: session)

                    // Dont't change aspect ratio
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

                    // Add preview
                    self.cameraView.layer.addSublayer(previewLayer!)
                }
            }
        } catch {
            print(error)
        }
    }

    @IBAction func ScanTapped(_ sender: Any) {
        // Camera setting
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        // Shoot
        output?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    // AVCapturePhotoCaptureDelegateのデリゲート
    // カメラで撮影が完了した後呼ばれる。撮影データを加工したり、アルバムに保存したりする。
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {

        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG形式で画像データを取得
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            // UIImage型に変換
            image = UIImage(data: photoData!)

            check()
        }
    }

    func check() {

        guard image != nil else {
            print("Image isn't set yet")
            return
        }

        checkImage = ImageMat(image: image!)

        let imageFeatureValue = checkImage!.featureValue

        // If classification is enabled, it tries to classify the drawings with the sticker classifier
        let imageLabel = ModelUpdater.predictLabelFor(imageFeatureValue)

        if let lbl = imageLabel {
            print("Label: \(lbl)")
        }
        else {
            print("Can't recognize")
            return
        }

        // Sprit the value into userId and ItemId
        let strArray = imageLabel!.components(separatedBy: ",")

        let storeId = strArray[0]
        print(strArray[0])

        let itemId = strArray[1]
        print(strArray[1])

        let dbRef = Database.database().reference()

        dbRef.child("retailers").child(storeId).child("items").observeSingleEvent(of: .value) { (snapshot) in

            // Declare an array to hold the photos
            var retrieveditems = [Item]()

            // Get the list of snapshots
            let snapshots = snapshot.children.allObjects as? [DataSnapshot]

            if let snapshots = snapshots {

                // Loop through each snapshot and parse out the photos
                for snap in snapshots {

                    // Try to create a photo from a snapshot
                    let i = Item(snapshot: snap)

                    // If successful, then add it to our array
                    if i != nil {
                        retrieveditems.insert(i!, at: 0)
                    }

                }

            }

            var counter = 0
            for retrieveditem in retrieveditems {
                if retrieveditem.itemId == itemId{
                    self.scanedItem = retrieveditems[counter]

                    print(retrieveditem.itemName!)
                }
                counter += 1
            }

            self.moveToItemView()

        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let ItemVC = segue.destination as? ConsumerViewItemViewController
    
        if let ItemVC = ItemVC {
    
            // Set the place for the detail view controller
            ItemVC.item = self.scanedItem
    
        }
    }

    func moveToItemView() {
        
        performSegue(withIdentifier: Constants.Segue.scanToShow, sender: self)
    }

    @IBAction func resetTapped(_ sender: Any) {
        ModelUpdater.resetDrawingClassifier()
    }


}



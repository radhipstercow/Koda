//
//  ImageMat.swift
//  Random
//
//  Created by Eisuke Tamatani on 3/23/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import CoreML
import CoreImage
import UIKit

struct ImageMat {
    private static let ciContext = CIContext()

    let image: UIImage

    var featureValue: MLFeatureValue {
        // Get the model's image constraints.
        let imageConstraint = ModelUpdater.imageConstraint
        
        let ciImage = CIImage(image: image)
        
        let cgImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        let imageFeatureValue = try? MLFeatureValue(cgImage: cgImage!,
                                                    constraint: imageConstraint)
        return imageFeatureValue!
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
}

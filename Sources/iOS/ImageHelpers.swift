//
//  ImageHelpers.swift
//  api-demo
//
//  Created by Eliot Andres on 22/03/2021.
//

import Foundation
import UIKit

extension UIImage {
    func scaled(by scale: CGFloat) -> UIImage {
//        let orientation = CGImagePropertyOrientation(rawValue: UInt32(imageOrientation.rawValue))!
        guard
            let scaledImage = CIImage(image: self)?.scaled(by: scale)
        else {
            return self
        }
        return UIImage(ciImage: scaledImage, scale: UIScreen.main.scale, orientation: imageOrientation)
    }
    
    func scaled(maxDimensions: CGSize) -> CGFloat {
        let scale = min(maxDimensions.width / size.width, maxDimensions.height / size.height)
        if scale >= 1 {
            return 1
        }
        return scale
    }
}

extension CIImage {
 
    func scaled(by scale: CGFloat) -> CIImage {
        guard scale != 1 else { return self }
        return applyingFilter("CILanczosScaleTransform", parameters: [kCIInputScaleKey: Float(scale),
                                                                      kCIInputAspectRatioKey: 1])
    }
}

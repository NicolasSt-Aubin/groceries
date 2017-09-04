//
//  UIImage+groceries.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-09-04.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension UIImage {
    
    class var loadingAnimatedImage: UIImage? {
        let string = "loading_%04d_Layer-%d"
        var images: [UIImage] = []
        
        for i in 1..<91 {
            let imageName = String(format: string, 90-i, i)
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
        }
        
        return UIImage.animatedImage(with: images, duration: 5)
    }
    
}

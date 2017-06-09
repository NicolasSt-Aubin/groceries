//
//  UIView+saptest.swift
//  saptest
//
//  Created by Nicolas St-Aubin on 2017-06-02.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension UIView {
    
    func borderize(width: CGFloat = 1, color: UIColor = .flatBlack) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}

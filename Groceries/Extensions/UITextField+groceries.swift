//
//  UITextField+groceries.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension UITextField {
    
    class func generateGRTextField() -> UITextField {
        let textField = UITextField()
        
        let paddingView = UIView()
        paddingView.frame.size.width = 20
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.backgroundColor = .white
        textField.borderize(width: 1, color: .flatSilver)
        textField.textColor = .flatMidnightBlue
        textField.textAlignment = .left
        textField.tintColor = .flatBelizeHole
        return textField
    }
    
}

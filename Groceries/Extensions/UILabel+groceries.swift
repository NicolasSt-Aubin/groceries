//
//  UILabel+groceries.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension UILabel {
    
    class func generateTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .flatBlack
        label.font = UIFont.grBoldFont(ofSize: 28)
        return label
    }
    
    class func generateInstructionLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .flatGrey
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }
    
}

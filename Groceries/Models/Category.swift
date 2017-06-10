//
//  Category.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var id: String!
    var name: String = ""
    var image: UIImage? = nil
    var color: UIColor = .flatBlack
    
    init(name: String, image: UIImage, color: UIColor) {
        self.name = name
        self.image = image
        self.color = color
    }
    
}

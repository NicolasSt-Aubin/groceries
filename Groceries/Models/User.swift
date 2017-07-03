//
//  User.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-07-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: String!
    var name: String = ""
    var image: UIImage? = nil
    
    init(id: String, name: String, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
}

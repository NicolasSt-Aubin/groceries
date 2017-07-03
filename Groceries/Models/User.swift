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
    var email: String = ""
    var image: UIImage? = nil
    
    var json: AnyObject {
        set {
            if let id = newValue["_id"] as? String {
                self.id = id
            }
            
            if let name = newValue["name"] as? String {
                self.name = name
            }
            
            if let email = newValue["email"] as? String {
                self.email = email
            }
        }
        get {
            return [
              "name": self.name,
              "email": self.email
            ] as AnyObject 
        }
    }
    
}

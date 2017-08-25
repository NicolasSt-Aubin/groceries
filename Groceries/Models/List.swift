//
//  List.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-07-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation

class List {
    var id: String!
    var name = ""
    var involvedUsers: [User] = []
    var elements: [Element] = []
    
    var json: AnyObject {
        set {
            if let id = newValue["_id"] as? String {
                self.id = id
            }
            
            if let name = newValue["name"] as? String {
                self.name = name
            }
            
            if let jsonUsers = newValue["involvedUsers"] as? [AnyObject] {
                for jsonUser in jsonUsers {
                    let user = User()
                    user.json = jsonUser
                    involvedUsers.append(user)
                }
            }
        }
        get {
            return [
                "name": self.name
            ] as AnyObject
        }
    }

}

func == (lhs:List,rhs:List) -> Bool {
    return lhs.id == rhs.id
}

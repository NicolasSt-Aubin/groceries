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
    var title = ""
    var users: [User] = []
    
    init(id: String, title: String, users: [User]) {
        self.id = id
        self.title = title
        self.users = users
    }
}

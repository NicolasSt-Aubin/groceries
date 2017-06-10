//
//  Element.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation

class Element {
    var id: String!
    var name: String = ""
    var price: Double? = nil
    var lastPurchaseDate: Date? = nil
    var active: Bool = false
    var inCart: Bool = false
    var category: Category!
    
    init(id: String, name: String, active: Bool, category: Category, price: Double? = nil, inCart: Bool = false) {
        self.id = id
        self.name = name
        self.active = active
        self.price = price
        self.category = category
        self.inCart = inCart
    }
    
}

func == (lhs:Element,rhs:Element) -> Bool {
    return lhs.id == rhs.id
}

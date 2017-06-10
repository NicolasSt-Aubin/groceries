//
//  TempDateService.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-09.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import UIKit

class TempDataService {
    
    class var categories: [Category] {
        return [
            Category(name: "poultry", image: Asset.poultry.image, color: UIColor(colorString:"#F7BC05") ),
            Category(name: "dairy", image: Asset.dairy.image, color: UIColor(colorString:"#91CED7") ),
            Category(name: "red meat", image: Asset.redMeat.image, color: UIColor(colorString:"#FC575E") ),
            Category(name: "vegies", image: Asset.vegies.image, color: UIColor(colorString:"#59AE7F") )
        ]
    }
    
    class var elements: [Element] {
        let cats = TempDataService.categories
        return [
            Element(id: "1", name: "steak", active: false, category: cats[2], price: 20.00),
            Element(id: "2", name: "chicken", active: false, category: cats[0], price: 15.00),
            Element(id: "3", name: "milk", active: false, category: cats[1]),
            Element(id: "4", name: "cheese", active: false, category: cats[1], price: 5.00),
            Element(id: "5", name: "brocoli", active: false, category: cats[3]),
            Element(id: "6", name: "turkey", active: false, category: cats[0], price: 23.00),
            Element(id: "7", name: "pork", active: false, category: cats[2], price: 17.00),
            Element(id: "8", name: "carrots", active: false, category: cats[3], price: 3.00),
            Element(id: "9", name: "salad", active: false, category: cats[3]),
            Element(id: "10", name: "yogourt", active: true, category: cats[1], price: 6.00),
            Element(id: "11", name: "eggs", active: true, category: cats[0], price: 4.00),
            Element(id: "12", name: "salsa", active: true, category: cats[3], price: 2.50, inCart: true)
        ]
    }
    
}

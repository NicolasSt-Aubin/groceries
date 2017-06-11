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
            Category(id: "c1", name: "poultry", image: Asset.poultry.image, color: UIColor(colorString:"#F7BC05") ),
            Category(id: "c2", name: "dairy", image: Asset.dairy.image, color: UIColor(colorString:"#91CED7") ),
            Category(id: "c3", name: "red meat", image: Asset.redMeat.image, color: UIColor(colorString:"#FC575E") ),
            Category(id: "c4", name: "vegies", image: Asset.vegies.image, color: UIColor(colorString:"#59AE7F") )
        ]
    }
    
    class var elements: [Element] {
        let cats = TempDataService.categories
        return [
            Element(id: "e1", name: "steak", active: false, category: cats[2], price: 20.00),
            Element(id: "e2", name: "chicken", active: false, category: cats[0], price: 15.00),
            Element(id: "e3", name: "milk", active: false, category: cats[1]),
            Element(id: "e4", name: "cheese", active: false, category: cats[1], price: 5.00),
            Element(id: "e5", name: "brocoli", active: false, category: cats[3]),
            Element(id: "e6", name: "turkey", active: false, category: cats[0], price: 23.00),
            Element(id: "e7", name: "pork", active: false, category: cats[2], price: 17.00),
            Element(id: "e8", name: "carrots", active: false, category: cats[3], price: 3.00),
            Element(id: "e9", name: "salad", active: false, category: cats[3]),
            Element(id: "e10", name: "yogourt", active: true, category: cats[1], price: 6.00),
            Element(id: "e11", name: "eggs", active: true, category: cats[0], price: 4.00),
            Element(id: "e12", name: "salsa", active: true, category: cats[3], price: 2.50, inCart: true),
            Element(id: "e13", name: "linguini pasta coucou", active: false, category: cats[3]),
            Element(id: "e14", name: "pasta linguini coucou", active: false, category: cats[2])
        ]
    }
    
}

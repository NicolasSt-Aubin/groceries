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
    var activationTimer: Timer? = nil
    
    init(id: String, name: String, active: Bool, category: Category, price: Double? = nil, inCart: Bool = false) {
        self.id = id
        self.name = name
        self.active = active
        self.price = price
        self.category = category
        self.inCart = inCart
    }
    
    func matchesQuery(query: String) -> Bool {
        return name.lowercased().trimmingCharacters(in: .whitespaces).contains(query)
    }
    
    /*func queryScore(query: String) -> Int {
        
        let queryWordArray = query.lowercased().components(separatedBy: " ").filter{$0 != ""}
        let nameWordArray = name.lowercased().components(separatedBy: " ").filter{$0 != ""}
        
        if queryWordArray.count == 0 {
            return 100
        }
        
        var score: Int = 0
        var orderIndexes: [Int] = []
        
        for word in queryWordArray {
            for i in 0..<nameWordArray.count {
                if word == nameWordArray[i] {
                    score += 20
                    orderIndexes.append(i)
                } else if nameWordArray[i].contains(word) {
                    score += 5
                    orderIndexes.append(i)
                }
            }
        }
        
        var sortingOperationCount: Int = 0
        
        var sorting = true
        
        while sorting {
            
            sorting = false
            
            for i in 0..<orderIndexes.count {
                if i+1 < orderIndexes.count {
                    if orderIndexes[i] > orderIndexes[i+1] {
                        
                        let temp = orderIndexes[i]
                        orderIndexes[i] = orderIndexes[i+1]
                        orderIndexes[i+1] = temp
                        
                        sortingOperationCount += 1
                        sorting = true
                    }
                }
            }
            
        }
        
        score -= sortingOperationCount * 5
        
        let differenceCount = nameWordArray.count - orderIndexes.count
        score -= differenceCount*5
        
        return score
        
        return 0
    }*/
    
}

func == (lhs:Element,rhs:Element) -> Bool {
    return lhs.id == rhs.id
}

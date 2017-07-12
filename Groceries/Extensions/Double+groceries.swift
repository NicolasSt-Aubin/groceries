//
//  Double+groceries.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-13.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

extension Double {
    
//    mutating func decimalRound() {
//        self = Darwin.round(self * 10) / 10
//        if getDecimals() < 0.5 {
//            
//        }
//    }
    
    mutating func getDecimals() -> Double {
        let x:Double = self
        let numberOfPlaces:Double = 1.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = Darwin.round((x.truncatingRemainder(dividingBy: 1.0)) * powerOfTen) / powerOfTen
        return targetedDecimalPlaces
    }
    
}

//
//  QuantityIndicator.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-16.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation

enum QuantityIndicator {
    case unit
    case kg
    case lbs
    
    var title: String {
        switch self {
        case .unit:
            return L10n.unit
        case .kg:
            return L10n.kg
        case .lbs:
            return L10n.lbs
        }
    }
}

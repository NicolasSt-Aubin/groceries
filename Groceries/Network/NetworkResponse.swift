//
//  NetworkResponse.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-07.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

struct NetworkResponse {
    var obj: AnyObject?
    var errorMessage: String?
    var time: Int?
    
    init(obj: AnyObject? = nil, errorMessage: String? = nil, time: Int? = nil) {
        self.obj = obj
        self.errorMessage = errorMessage
        self.time = time
    }
}

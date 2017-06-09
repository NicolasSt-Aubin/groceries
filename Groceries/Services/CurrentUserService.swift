//
//  CurrentUserService.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import KeychainSwift

class CurrentUserService {
    
    class var savedToken: String? {
        get {
            let keychain = KeychainSwift()
            return keychain.get("saved_token")
        }
        set {
            guard let newString = newValue else {
                return
            }
            
            let keychain = KeychainSwift()
            keychain.set(newString, forKey: "saved_token")
        }
    }
    
}

//
//  CurrentUserService.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import KeychainSwift

class CurrentUserService {
    
    // MARK: - Class properties
    
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
    
    // MARK: - Properties
    
    var userLists: [List] = []
    
    var selectedList: List? {
        if userLists.count > 0 {
            return userLists[0]
        }
        return nil
    }
    
    // MARK: - Singleton logic
    
    static let shared = CurrentUserService()
    
    fileprivate init() {}
    
}

//
//  APIService.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-08.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation

class APIService {
    
    class func login(email: String, password: String, success: @escaping (() -> Void), failure: ((String) -> Void)? = nil) {
        
        let params: [String: AnyObject] = [
            "email": email as AnyObject,
            "password": password as AnyObject
        ]
        
        NetworkRequest.login.execute(params) { response in
            if let error = response.errorMessage {
                failure?(error)
                return
            }
            
            guard let object = response.obj else {
                failure?(L10n.generalNetworkError)
                return
            }
            
            if let token = object["token"] as? String {
                CurrentUserService.savedToken = token
                success()
                return
            }
            
            failure?(L10n.generalNetworkError)
            return
            
        }
        
    }
    
    class func fetchLists(success: @escaping ((_ lists: [List]) -> Void), failure: ((String) -> Void)? = nil) {
        
        NetworkRequest.fetchLists.execute() { response in
            if let error = response.errorMessage {
                failure?(error)
                return
            }
            
            guard let jsonLists = response.obj as? [AnyObject] else {
                failure?(L10n.generalNetworkError)
                return
            }
            
            var lists: [List] = []
            
            for jsonList in jsonLists {
                let list = List()
                list.json = jsonList
                lists.append(list)
            }
            
            success(lists)
            
        }
        
    }
    
}

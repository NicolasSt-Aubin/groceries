//
//  NetworkRequest.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-07.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Alamofire

let APIURL = "http://192.168.1.103:9000/api/"

enum NetworkRequest {
    
    // AUTH
    case login
    case register
    
    // CATEGORIES
    case fetchCategories
    
    // ELEMENTS
    case createElement
    case activateElement
    case deactivateElement
    
    // LISTS
    case fetchLists
    case getListById
    case createList
    case updateList
    case inviteUserToList
    case leaveList
    case resetList
    case deleteList
    
    var url: String {
        switch self {
        case .login:
            return APIURL + "login"
        case .register:
            return APIURL + "users"
        case .fetchCategories:
            return APIURL + "categories"
        case .createElement:
            return APIURL + "elements"
        case .activateElement:
            return APIURL + "elements/%@/activate"
        case .deactivateElement:
            return APIURL + "elements/%@/deactivate"
        case .fetchLists, .createList:
            return APIURL + "lists"
        case .getListById, .updateList, .deleteList:
            return APIURL + "lists/%@"
        case .inviteUserToList:
            return APIURL + "lists/%@/invite"
        case .leaveList:
            return APIURL + "lists/%@/leave"
        case .resetList:
            return APIURL + "lists/%@/reset"
        }
    }
    
    var requestMethod: HTTPMethod {
        switch self {
        case .login, .register, .createList, .createElement:
            return .post
        case .fetchLists, .fetchCategories, .getListById:
            return .get
        case .activateElement, .deactivateElement, .updateList, .inviteUserToList, .leaveList, .resetList:
            return .put
        case .deleteList:
            return .delete
        }
    }
    
    var headers: [String:String]? {
        var headers = ["key": "1hFjr03RMjdi49KNDSj94j45JK878ndhuJ"]
        if let token = CurrentUserService.savedToken {
            headers["x-access-token"] = token
        }
        return headers
    }
    
    // MARK: - Public call executers
    
    func execute(_ params: [String: AnyObject]? = nil, urlArguments: [CVarArg] = [], completion: ((_ response: NetworkResponse) -> Void)? = nil) {
        
        let completeUrl = String(format: url, arguments: urlArguments)
        
        Alamofire.request(completeUrl, method: requestMethod, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            completion?(self.handleResponse(response: response))
        }
        
    }
    
    // MARK: - Private methods
    
    fileprivate func handleResponse(response: DataResponse<Any>) -> NetworkResponse {
        
        if response.result.isSuccess  {
            if let jsonResponse = response.result.value as? [String:AnyObject] {
                if let success = jsonResponse["success"] as? Bool {
                    if success {
                        return NetworkResponse(obj: jsonResponse["data"], errorMessage: nil, time: jsonResponse["time"] as? Int)
                    } else {
                        if let message = jsonResponse["message"] as? String {
                            return NetworkResponse(obj: nil, errorMessage: message, time: jsonResponse["time"] as? Int)
                        }
                    }
                }
            }
        }
        
        return NetworkResponse(obj: nil, errorMessage: L10n.generalNetworkError)
    }
    
}

//
//  Popup.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-08-23.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import PKHUD

/**
 * Helper Class for HUD
 */
class Popup{
    
    static func showText(_ _string:String){
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: _string)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    static func showProgress(_ _string:String = ""){
        PKHUD.sharedHUD.contentView = PKHUDProgressView(subtitle: _string)
        PKHUD.sharedHUD.show()
    }
    
    static func showSuccess(_ _string:String,completion: (() -> Void)? = nil){
        PKHUD.sharedHUD.contentView = PKHUDSuccessView(subtitle: _string)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2.0,completion:{(isComplete) in
            completion?()
        })
    }
    
    static func showError(_ _string:String = ""){
        PKHUD.sharedHUD.contentView = PKHUDErrorView(subtitle: _string)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    static func hide(){
        PKHUD.sharedHUD.hide()
    }
    
    static func isVisible() -> Bool{
        return PKHUD.sharedHUD.isVisible
    }
    
}


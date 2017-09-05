//
//  NavigationManager.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-09-04.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    // MARK: - Singleton logic
    
    static let main: NavigationManager = {
        return NavigationManager()
    }()
    
    fileprivate override init() { super.init() }
    
}

extension NavigationManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is SettingsViewController {
            return PresentAnimationController()
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is SettingsViewController {
            return DismissAnimationController()
        }
        return nil
    }
    
}

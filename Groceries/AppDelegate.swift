//
//  AppDelegate.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-07.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = SettingsViewController()//CurrentUserService.savedToken == nil ? LoginViewController() : MainNavigationController()
        window?.makeKeyAndVisible()
        
        let launchViewController = LaunchViewController()
        launchViewController.modalPresentationStyle = .overCurrentContext
        window?.rootViewController?.present(launchViewController, animated: false, completion: nil)
        
        return true
    }

    // MARK: - User persistence navigation methods
    
    func goToMainAppContent(_ completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromRight , animations: { [weak self] in
            self?.window?.rootViewController = ListManagerViewController()
        }, completion: completion)
    }
    
    func goToSignUp() {
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionFlipFromLeft , animations: { [weak self] in
            self?.window!.rootViewController = LoginViewController()
        }, completion: nil)
    }
    
}


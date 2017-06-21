//
//  BaseViewController.swift
//  paradym
//
//  Created by Ali Laraki on 2016-11-30.
//  Copyright © 2016 Ali Laraki. All rights reserved.
//

import UIKit
import PKHUD

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicatorView.startAnimating()
                loadingView.isHidden = false
                loadingView.alpha = 1
            } else {
                self.fadeOutLoadingView()
            }
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var statusBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        return view
    }()
    
    fileprivate lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.tintColor = .flatMidnightBlue
        activityIndicatorView.color = .flatMidnightBlue
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.sizeToFit()
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        
        view.addSubview(statusBackgroundView)
        view.addSubview(whiteView)
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicatorView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        statusBackgroundView.frame.size.width = view.bounds.width
        statusBackgroundView.frame.size.height = 20
        view.bringSubview(toFront: statusBackgroundView)
        
        whiteView.frame.size.width = view.bounds.width
        if let tabBar = tabBarController?.tabBar {
            whiteView.frame.size.height = tabBar.frame.height
        }
        
        whiteView.frame.origin.y = view.frame.maxY
        
        view.bringSubview(toFront: loadingView)
        
        loadingView.frame = view.bounds
        
        activityIndicatorView.center = CGPoint(x: loadingView.bounds.width/2, y: loadingView.bounds.height/2)
    }
    
    // MARK: - Public methods
    
    func presentError(_ error: String) {
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: error)
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 1.0)
    }
    
    // MARK: - Private methods
    
    fileprivate func fadeOutLoadingView() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.loadingView.alpha = 0
            
        }, completion: { _ in
            
            self.loadingView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            
        })
        
    }
    
}

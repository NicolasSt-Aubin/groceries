//
//  LaunchViewController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-19.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.logo.image
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        backgroundView.addSubview(logoImageView)
        
        backgroundView.frame = view.bounds
        logoImageView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 1, animations: {
//            self.logoImageView.alpha = 0
//            self.logoImageView.frame.size.height = 20
            self.backgroundView.frame.size.height = 20
//            self.logoImageView.center = CGPoint(x: self.backgroundView.bounds.width/2, y: self.backgroundView.bounds.height/2)
        }, completion: { completed in
            self.dismiss(animated: false, completion: nil)
        })
        
    }

}

//
//  LaunchViewController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-06-19.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .flatBelizeHole
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.logo.image
        imageView.sizeToFit()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(logoImageView)
        
        backgroundView.frame = view.bounds
        logoImageView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 1, animations: {
            self.logoImageView.alpha = 0
            self.logoImageView.frame.size.height = 20
            self.backgroundView.frame.size.height = 20
            self.logoImageView.center = CGPoint(x: self.backgroundView.bounds.width/2, y: self.backgroundView.bounds.height/2)
        }, completion: { completed in
            self.dismiss(animated: false, completion: nil)
        })
        
    }

}

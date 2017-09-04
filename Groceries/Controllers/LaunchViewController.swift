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
        imageView.image = UIImage.loadingAnimatedImage
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        APIService.fetchLists(success: { lists in
            CurrentUserService.shared.userLists = lists
            self.completeAnimation()
        }, failure: { error in
            // TO DO
        })
        
    }
    
    // MARK: - Private Methods
    
    func completeAnimation() {

        UIView.animate(withDuration: 0.8, animations: {
            self.backgroundView.frame.size.height = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
        
    }

}


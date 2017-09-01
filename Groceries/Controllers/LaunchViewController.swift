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
    
    override func viewDidLayoutSubviews() {
        backgroundView.frame = view.bounds
        logoImageView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
    }
    
    // MARK: - Private Methods
    
    func completeAnimation() {

//        let customPresentAnimationController =
//        let vc = ListManagerViewController()
//        vc.transitioningDelegate = self
//        self.present(vc, animated: true, completion: nil)
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: nil)
    }

}

extension LaunchViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomPresentAnimationController()
//    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
}

//
//  CustomPresentAnimationController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-09-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let containerView = transitionContext.containerView
        
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)!
        let snapshotContainerView = UIView()
        snapshotContainerView.clipsToBounds = true
        snapshotContainerView.frame = fromViewController.view.frame
        snapshotView.frame = snapshotContainerView.frame
        snapshotContainerView.addSubview(snapshotView)
        containerView.addSubview(snapshotContainerView)
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animate(withDuration: 2.5, animations: {
            snapshotContainerView.frame.size.height = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

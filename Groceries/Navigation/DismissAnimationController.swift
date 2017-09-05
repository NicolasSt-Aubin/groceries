//
//  CustomPresentAnimationController.swift
//  Groceries
//
//  Created by Nicolas St-Aubin on 2017-09-01.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import UIKit

class DismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        
        toViewController.view.frame = finalFrameForVC
        containerView.addSubview(toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)!
        let snapshotContainerView = UIView()
        snapshotContainerView.clipsToBounds = true
        snapshotContainerView.frame = fromViewController.view.frame
        snapshotView.frame = snapshotContainerView.frame
        snapshotContainerView.addSubview(snapshotView)
        containerView.addSubview(snapshotContainerView)
        
        containerView.backgroundColor = .clear
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animate(withDuration: 0.8, animations: {
            snapshotContainerView.frame.size.height = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}

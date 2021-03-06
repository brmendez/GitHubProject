//
//  HideImageAnimator.swift
//  GitHubProject
//
//  Created by Brian Mendez on 10/23/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

import UIKit

class HideImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Rectangle denoting where the animation should start from
    // Used for positioning the toViewController's view
    var origin: CGRect?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1.0
    }
    //transtition context, 3 important things. Ref to VC i am coming from, ref to VC I am going to, and the containerView
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserDetailViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UsersViewController
        
        let containerView = transitionContext.containerView()
        //containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: { () -> Void in
            fromViewController.view.frame = self.origin!
            fromViewController.imageView!.frame = fromViewController.view.bounds
            toViewController.view.alpha = 1.0
            }) { (finished) -> Void in
                transitionContext.completeTransition(finished)
        }
    }
}

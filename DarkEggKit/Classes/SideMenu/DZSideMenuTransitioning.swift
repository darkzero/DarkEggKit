//
//  DZSideMenuTransition.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/02.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

public class DZSideMenuTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    public enum TransitionType: String {
        case show
        case hide
    }
    
    public enum AnimationType: String {
        case `default`
        case cover
    }
    
    var transitionType: TransitionType = .show
    //var animationType: AnimationType = .default
    var configuration: DZSideMenuConfiguration = DZSideMenuConfiguration()
    
    class func transitioning(with type: TransitionType, animationType: AnimationType, configuration: DZSideMenuConfiguration) -> DZSideMenuTransitioning {
        let tran = DZSideMenuTransitioning()
        //tran.animationType = animationType
        tran.transitionType = type
        tran.configuration = configuration
        return tran
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.transitionType {
        case .show:
            self.animationViewShow(transitionContext)
        case .hide:
            self.animationViewHide(transitionContext)
        }
    }

}

extension DZSideMenuTransitioning {
    private func animationViewShow(_ context: UIViewControllerContextTransitioning) {
        switch self.configuration.animationType {
        case .default:
            self.animationViewShowDefault(context)
        case .cover:
            self.animationViewShowCover(context)
        }
    }
    
    private func animationViewShowDefault(_ context: UIViewControllerContextTransitioning) {
        // get from and to viewcontroller
        guard let fromVC = context.viewController(forKey: .from), let toVC = context.viewController(forKey: .to) else {
            return
        }
        // get container view
        let containerView = context.containerView
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        // set mask
        let maskView = DZSideMenuMask.shared
        maskView.frame = fromVC.view.bounds;
        fromVC.view.addSubview(maskView)
        // menu width
        let menuWidth: CGFloat = CGFloat(self.configuration.distance)
        var x: CGFloat = CGFloat(-menuWidth/2.0)
        var ret: CGFloat = 1.0
        // calc the transform
        var fromTransform   = CGAffineTransform()
        var toTransform     = CGAffineTransform()
        if self.configuration.position == .right {
            x = dzScreenWidth - menuWidth/2.0
            ret = -1.0
        }
        toVC.view.layer.shadowColor = UIColor.black.cgColor
        toVC.view.layer.shadowOffset = CGSize(width: 4, height: 4)
        toVC.view.layer.shadowRadius = 2
        toVC.view.frame = CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: menuWidth, height: containerView.bounds.size.height))
        fromTransform = CGAffineTransform(translationX: CGFloat(ret*menuWidth), y: 0.0)
        // TODO: 
        // let fromTransform1 = CGAffineTransform(translationX: CGFloat(ret*menuWidth), y: 0.0)
        // let fromTransform2 = CGAffineTransform(scaleX: CGFloat(self.configuration.scaleY), y: CGFloat(self.configuration.scaleY))
        // fromTransform = fromTransform1.concatenating(fromTransform2)
        if self.configuration.position == .right {
            toTransform = CGAffineTransform(translationX: ret*(x-containerView.bounds.width+menuWidth), y: 0.0)
        }
        else {
            toTransform = CGAffineTransform(translationX: ret*menuWidth/2, y: 0.0)
        }
        // animation
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: context), delay: 0.0, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                fromVC.view.transform = fromTransform
                toVC.view.transform = toTransform
                maskView.alpha = CGFloat(self.configuration.maskAlpha)
            })
        }) { (finished) in
            if !context.transitionWasCancelled {
                maskView.isUserInteractionEnabled = true
                if toVC.isKind(of: UINavigationController.self) {
                    //maskView.toViewSubViews = fromVC.view.subviews;
                }
                context.completeTransition(!(context.transitionWasCancelled))
                containerView.addSubview(fromVC.view)
            }
            else {
                context.completeTransition(!(context.transitionWasCancelled))
            }
        }
        return
    }
    
    private func animationViewShowCover(_ context: UIViewControllerContextTransitioning) {
        // get from and to viewcontroller
        guard let fromVC = context.viewController(forKey: .from), let toVC = context.viewController(forKey: .to) else {
            return
        }
        // get container view
        let containerView = context.containerView
        // set mask
        let maskView = DZSideMenuMask.shared
        maskView.frame = fromVC.view.bounds
        fromVC.view.addSubview(maskView)
        
        let menuWidth: CGFloat = CGFloat(self.configuration.distance)
        var x: CGFloat = -menuWidth
        var ret: CGFloat = 1.0
        if self.configuration.position == .right {
            x = dzScreenWidth// - menuWidth/2.0
            ret = -1.0
        }
        toVC.view.frame = CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: menuWidth, height: containerView.bounds.size.height))
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        //var toTransform = CGAffineTransform(translationX: 0, y: 0)
        let toTransform = CGAffineTransform(translationX: ret*menuWidth, y: 0.0)
        // animation
        UIView.animate(withDuration: self.transitionDuration(using: context), animations: {
            //fromVC.view.transform = fromTransform
            toVC.view.transform = toTransform
            maskView.alpha = CGFloat(self.configuration.maskAlpha)
        }) { (finished) in
            if !context.transitionWasCancelled {
                if toVC.isKind(of: UINavigationController.self) {
                    //maskView.toViewSubViews = fromVC.view.subviews;
                }
                context.completeTransition(!(context.transitionWasCancelled))
                containerView.addSubview(fromVC.view)
                containerView.bringSubviewToFront(toVC.view)
                maskView.isUserInteractionEnabled = true
            }
            else {
                context.completeTransition(!(context.transitionWasCancelled))
            }
        }
    }
    
    private func animationViewHide(_ context: UIViewControllerContextTransitioning) {
        let fromVC = context.viewController(forKey: .from)
        let toVC = context.viewController(forKey: .to)
        // mask
        let maskView = DZSideMenuMask.shared
        // animation
        UIView.animate(withDuration: self.transitionDuration(using: context), animations: {
            fromVC?.view.transform = CGAffineTransform.identity
            toVC?.view.transform = CGAffineTransform.identity
            maskView.alpha = 0
        }) { (finished) in
            if !context.transitionWasCancelled {
                maskView.removeFromSuperview()
                UIApplication.shared.keyWindow?.insertSubview((toVC?.view)!, at: 0)
            }
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

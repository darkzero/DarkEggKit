//
//  DZSideMenuAnimator.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/02.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

class DZSideMenuAnimator: NSObject {
    var configuration: DZSideMenuConfiguration = DZSideMenuConfiguration()
    var animationType: DZSideMenuTransitioning.AnimationType = .default
    
    var interactiveShow: DZSideMenuInteractiveTransition?
    var interactiveHidden: DZSideMenuInteractiveTransition?
    
    init(with configuration: DZSideMenuConfiguration) {
        super.init()
        self.configuration = configuration
    }
    
    class func animator(with configuration: DZSideMenuConfiguration) -> DZSideMenuAnimator {
        return DZSideMenuAnimator(with: configuration)
    }
    
    deinit {
        //print("\(#file),\(#function)")
    }
}

extension DZSideMenuAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DZSideMenuTransitioning.transitioning(with: .show, animationType: self.animationType, configuration: self.configuration)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DZSideMenuTransitioning.transitioning(with: .hide, animationType: self.animationType, configuration: self.configuration)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interactiveShow?.interacting ?? false) ? self.interactiveShow : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interactiveHidden?.interacting ?? false) ? self.interactiveHidden : nil
    }
}

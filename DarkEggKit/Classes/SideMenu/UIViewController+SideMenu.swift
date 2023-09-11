//
//  UIViewController+SideMenu.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/02.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

extension UIViewController {
    private struct AssociatedKeys {
        static var kDZSideMenuAnimator = "kDZSideMenuAnimator"
    }
    
    private var animator: DZSideMenuAnimator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.kDZSideMenuAnimator, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.kDZSideMenuAnimator) as? DZSideMenuAnimator)
        }
    }
    
    public func dz_showSideMenu(_ vc: UIViewController, configuration: DZSideMenuConfiguration? = nil) {
        // fix for iOS 13,
        // in iOS 13 default modalPresentationStyle is .automatic
        // must be .currentContext
        vc.modalPresentationStyle = .custom
        
        var _config = configuration
        if _config == nil {
            _config = DZSideMenuConfiguration()
        }
        
        var animator = (objc_getAssociatedObject(vc, &AssociatedKeys.kDZSideMenuAnimator) as? DZSideMenuAnimator)
        if animator == nil {
            animator = DZSideMenuAnimator(with: _config!)
            objc_setAssociatedObject(vc, &AssociatedKeys.kDZSideMenuAnimator, animator, .OBJC_ASSOCIATION_RETAIN)
        }
        vc.transitioningDelegate = animator
        
        let hide = DZSideMenuInteractiveTransition(with: .hide)
        hide.menuVC = vc
        
        animator?.interactiveHidden = hide
        animator?.configuration = _config!
        //animator?.animationType = .default
        
        self.present(vc, animated: true, completion: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.onMaskViewTapped(_:)), name: NSNotification.Name.DZSideMenu.Tap, object: nil)
    }
    
    public func hideSideMenu(completion: (()->Void)? = nil) {
        NotificationCenter.default.post(name: Notification.Name.DZSideMenu.Tap, object: self)
        completion?()
    }
}

extension UIViewController {
//    @objc internal func onMaskViewTapped(_ notification: Notification) {
//        NotificationCenter.default.removeObserver(self)
//        //self.dismiss(animated: true, completion: nil)
//    }
}

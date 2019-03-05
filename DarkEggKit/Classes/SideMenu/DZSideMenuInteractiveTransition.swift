//
//  DZSideMenuInteractiveTransition.swift
//  UIUX_iOS_App
//
//  Created by Yuhua Hu on 2019/02/02.
//  Copyright © 2019 Yuhua Hu. All rights reserved.
//

import UIKit

public class DZSideMenuInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var configuration: DZSideMenuConfiguration?
    var interacting: Bool = false
    var transitionType: DZSideMenuTransitioning.TransitionType = .show
    var menuVC: UIViewController?
    
    init(with transitionType: DZSideMenuTransitioning.TransitionType) {
        super.init()
        self.transitionType = transitionType
        NotificationCenter.default.addObserver(self, selector: #selector(self.onMaskViewTapped(_:)), name: NSNotification.Name.DZSideMenu.Tap, object: nil)
    }
    
    deinit {
        print(#function)
    }
}

extension DZSideMenuInteractiveTransition {
    @objc internal func onMaskViewTapped(_ notification: Notification) {
        self.menuVC?.dismiss(animated: true, completion: nil)
    }
}

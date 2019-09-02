//
//  DZSideMenuMask.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/03.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

class DZSideMenuMask: UIView {
    static let shared: DZSideMenuMask = {DZSideMenuMask(frame: CGRect.zero)}()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 13, *) {
            //self.backgroundColor = .systemGray
            self.backgroundColor = .gray
        }
        else {
            self.backgroundColor = .gray
        }
        self.alpha = 0.0;
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onMaskTap(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
}

extension DZSideMenuMask {
    @objc func onMaskTap(_ tap: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: Notification.Name.DZSideMenu.Tap, object: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

extension Notification.Name {
    enum DZSideMenu {
        static let Tap = Notification.Name(rawValue: "DZSideMenu_TapNotication")
    }
}

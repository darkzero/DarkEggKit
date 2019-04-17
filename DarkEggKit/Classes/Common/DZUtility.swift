//
//  DZUtility.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/03/06.
//

import UIKit

class DZUtility: NSObject {
    class func safeAreaInsetsOf(_ view: UIView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            // Fallback on earlier versions
            return UIEdgeInsets.zero;
        }
    }
}

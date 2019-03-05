//
//  UIViewController+PopupMessage.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/03/04.
//

import UIKit

// MARK: - Popup message
extension UIViewController {
    public func showPopupInfo(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .light, type: .info, display: .bubbleTop, callback: callback)
    }
    
    public func showPopupWarning(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .light, type: .warning, display: .bubbleTop, callback: callback)
    }
    
    public func showPopupError(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .light, type: .error, display: .bubbleTop, callback: callback)
    }
}

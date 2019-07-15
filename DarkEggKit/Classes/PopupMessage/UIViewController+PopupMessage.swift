//
//  UIViewController+PopupMessage.swift
//  DarkEggKit/PopupMessage
//
//  Created by darkzero on 2019/01/24.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

public protocol DarkEggPopupMessageProtocol: UIViewController {
    func showPopupInfo(_ message: String, callback: (()->Void)?)
    func showPopupWarning(_ message: String, callback: (()->Void)?)
    func showPopupError(_ message: String, callback: (()->Void)?)
}

// MARK: - Popup message
extension DarkEggPopupMessageProtocol {
    public func showPopupInfo(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .undefined, type: .info, display: .bubbleTop, callback: callback)
    }
    
    public func showPopupWarning(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .undefined, type: .warning, display: .bubbleTop, callback: callback)
    }
    
    public func showPopupError(_ message: String, callback: (()->Void)? = nil) {
        DZPopupMessage.show(message, theme: .undefined, type: .error, display: .bubbleTop, callback: callback)
    }
}

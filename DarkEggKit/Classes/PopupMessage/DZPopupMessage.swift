//
//  DZPopupMessage.swift
//  DarkEggKit/PopupMessage
//
//  Created by darkzero on 2019/01/24.
//  Copyright © 2019 darkzero. All rights reserved.
//

public struct Message {
    var text: String = ""
    var theme: DZPopupMessage.Theme = .undefined
    var type: DZPopupMessage.MessageType = .info
    var display: DZPopupMessage.DisplayType = .rise
    var disappearDelay: TimeInterval = 1.5
    
    
    var imageName: String {
        switch self.type {
        case .info:
            return "dz_icon_info"
        case .warning:
            return "dz_icon_warning"
        case .error:
            return "dz_icon_error"
        }
    }
    
    var textColor: UIColor {
        switch self.type {
        case .info:
            switch self.theme {
            case .light:
                return .darkText
            case .dark:
                return .white
            case .undefined:
                if #available(iOS 13, *) {
                    return .label
                }
                else {
                    return .darkText
                }
            }
        case .warning:
            if #available(iOS 13, *) {
                return .systemOrange
            }
            else {
                return .orange
            }
        case .error:
            if #available(iOS 13, *) {
                return .systemRed
            }
            else {
                return .red
            }
        }
    }
    
    var backColor: UIColor {
        var color: UIColor = .white
        switch self.theme {
        case .light:
            color = RGB_HEX("f2f2f7", 1.0)
        case .dark:
            color = RGB_HEX("1c1c1e", 1.0)
        case .undefined:
            if #available(iOS 13, *) {
                color = .tertiarySystemBackground
            }
            else {
                color = .white
            }
        }
        return color.withAlphaComponent(0.8)
    }
    
//    var foreColor: UIColor {
//        switch self.type {
//        case .info:
//            if #available(iOS 13, *) {
//                return .label
//            }
//            else {
//                return .darkText
//            }
//        case .warning:
//            if #available(iOS 13, *) {
//                return .systemOrange
//            }
//            else {
//                return .orange
//            }
//        case .error:
//            if #available(iOS 13, *) {
//                return .systemRed
//            }
//            else {
//                return .red
//            }
//        }
//    }
}

public class DZPopupMessage {
    
    public enum DisplayType: String {
        case rise
        case drop
        case bubbleTop
        case bubbleBottom
    }
    
    public enum MessageType: String {
        case info
        case warning
        case error
    }
    
    public enum Theme: String {
        case dark
        case light
        case undefined
    }
    
    public class func show( _ msg: Message, in view: UIView? = nil, callback: (()->Void)? = nil) {
        let msgView = DZPopupMessageView(message: msg, in: view, callback: callback)
        DZPopupMessageQueueManager.shared.addPopupMessage(msgView)
    }
    
    public class func show( _ text: String, theme: Theme = .undefined, type: MessageType = .info, display: DisplayType = .bubbleTop, callback: (()->Void)? = nil) {
        let msg = Message(text: text, theme: theme, type: type, display: display, disappearDelay: 1.5)
        self.show(msg, callback: callback)
    }
}

extension DZPopupMessage {
    public class func pause() {
        //DZPopupMessageQueueManager.shared.pause()
    }
    
    public class func clearQueue() {
        DZPopupMessageQueueManager.shared.clearAllQueue()
    }
}

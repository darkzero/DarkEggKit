//
//  DZPopupMessage.swift
//  DZPopupMessageView
//
//  Created by Yuhua Hu on 2019/01/24.
//

public struct Message {
    var text: String = ""
    var theme: DZPopupMessage.Theme = .light
    var type: DZPopupMessage.MessageType = .info
    var display: DZPopupMessage.DisplayType = .rise
    var disappearDelay: TimeInterval = 1.5
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
    }
    
    public class func show( _ msg: Message, in view: UIView? = nil, callback: (()->Void)? = nil) {
        let msgView = DZPopupMessageView(message: msg, in: view, callback: callback)
        DZPopupMessageQueueManager.shared.addPopupMessage(msgView)
    }
    
    public class func show( _ text: String, theme: Theme = .light, type: MessageType = .info, display: DisplayType = .bubbleTop, callback: (()->Void)? = nil) {
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

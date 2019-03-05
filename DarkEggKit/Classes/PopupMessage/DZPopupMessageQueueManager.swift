//
//  DZPopupMessageQueueManager.swift
//  Pods
//
//  Created by darkzero on 16/5/15.
//
//

import UIKit

public class DZPopupMessageQueueManager: NSObject {
    // MARK: - Properties
    lazy var messageQueuse: DZPopupMessageQueue = {
        let queue = DZPopupMessageQueue.shared
        return queue
    }()
    
    var isRunning = false
    
    //MARK: - Singleton
    static let shared : DZPopupMessageQueueManager = {DZPopupMessageQueueManager()}()
    
    // MARK: - init
    override init() {
        super.init()
        //self.messageQueuse.addObserver(self, forKeyPath: "messageList", options: NSKeyValueObservingOptions([.old,.new]), context: nil)
        self.messageQueuse.addObserver(self, forKeyPath: #keyPath(DZPopupMessageQueue.messageList), options: NSKeyValueObservingOptions([.old,.new]), context: nil)
    }
    
    // MARK: - Open Functions
    internal func addPopupMessage(_ message: DZPopupMessageView) {
        DispatchQueue(label: "add_popup_message", attributes: []).sync {
            self.messageQueuse.addMessage(message)
        }
    }
    
    internal func clearAllQueue() {
        if ( isRunning ) {
            isRunning = false
            self.messageQueuse.messageList.removeAll()
        }
    }
    
    internal func next() {
        if ( self.messageQueuse.count() > 0  ) {
            self.isRunning = true
            let msgPopup = (self.messageQueuse.messageList.last)! as DZPopupMessageView
            msgPopup.showWithAnimation(true)
        }
        else {
            self.isRunning = false
        }
    }
    
    // MARK: - KVO
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ( keyPath == #keyPath(DZPopupMessageQueue.messageList) ) {
            if ( !self.isRunning ) {
                self.next()
            }
        }
    }
}

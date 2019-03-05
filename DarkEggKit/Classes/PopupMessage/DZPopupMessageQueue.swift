//
//  DZPopupMessageQueue.swift
//  Pods
//
//  Created by darkzero on 16/5/15.
//
//

import UIKit

public class DZPopupMessageQueue: NSObject {
    //MARK: - properties
    @objc dynamic var messageList: [DZPopupMessageView] = []
    var messageCount: Int = 0
    
    // MARK: - Singleton
    static var shared: DZPopupMessageQueue = {DZPopupMessageQueue()}()
    
    // MARK: - Insert & Remove Objects
    /// insert a message object into queue array at index
    func insertObject(_ object: DZPopupMessageView, inMessageListAtIndex index: Int) {
        self.messageList.insert(object, at: index)
    }
    
    /// remove a message object into queue array
    func removeObjectFromMessageListAtIndex(_ index: Int) {
        self.messageList.remove(at: index)
    }
    
    /// add a message object into queue array
    func addMessage(_ message: DZPopupMessageView) {
        self.insertObject(message, inMessageListAtIndex: 0)
    }
    
    /// get messages count in list
    func count() -> Int {
        let c = DZPopupMessageQueue.shared.messageList.count
        return c
    }
}

//
//  PopupMessageViewController.swift
//  DZPopupMessageSample
//
//  Created by darkzero on 2019/01/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class PopupMessageViewController: UIViewController {
    @IBOutlet var messageField: UITextField!
    @IBOutlet var themeSegment: UISegmentedControl!
    @IBOutlet var typeSegment: UISegmentedControl!
    @IBOutlet var displaySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Logger.debug()
    }
    
    deinit {
        Logger.debug()
    }
}

extension PopupMessageViewController {
    @IBAction func onButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        var msg = self.messageField.text ?? ""
        if msg.count <= 0 {
            msg = "Test Message"
        }
        
        // theme
        let theme: DZPopupMessage.Theme = {
            switch self.themeSegment.selectedSegmentIndex {
            case 0:
                return .light
            case 1:
                return .dark
            case 2:
                return .undefined
            default:
                return .light
            }
        }()
        // type
        let type: DZPopupMessage.MessageType = {
            switch self.typeSegment.selectedSegmentIndex {
            case 0:
                return .info
            case 1:
                return .warning
            case 2:
                return .error
            default:
                return .info
            }
        }()
        // display
        let display: DZPopupMessage.DisplayType = {
            switch self.displaySegment.selectedSegmentIndex {
            case 0:
                return .rise
            case 1:
                return .drop
            case 2:
                return .bubbleTop
            case 3:
                return .bubbleBottom
            default:
                return .bubbleBottom
            }
        }()
        
        DZPopupMessage.show(msg, theme: theme, type: type, display: display, callback: {
            // TODO: Add callback here
        })
    }
}

extension PopupMessageViewController {
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

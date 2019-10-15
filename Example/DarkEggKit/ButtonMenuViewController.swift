//
//  ButtonMenuViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/03/06.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class ButtonMenuViewController: UIViewController, DarkEggPopupMessageProtocol {
    var buttonMenu: DZButtonMenu = DZButtonMenu()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = DZButtonMenuConfiguration.default()
        config.location = .rightBottom
        config.style = .line
        config.direction = .up
        self.buttonMenu = DZButtonMenu(configuration: config)
        self.buttonMenu.addButton(title: "Automatic") {
            self.showPopupInfo("Button [Automatic] clicked")
        }
        self.buttonMenu.addButton(title: "Block User") {
            self.showPopupInfo("Button [Block User] clicked")
        }
        self.buttonMenu.addButton(title: "Call for help") {
            self.showPopupInfo("Button [Call for help] clicked")
        }
        self.view.addSubview(self.buttonMenu)

        let config1 = DZButtonMenuConfiguration.default()
        config1.location = .leftBottom
        config1.style = .sector
        config1.direction = .down
        let btnMenu = DZButtonMenu(configuration: config1)
        btnMenu.addButton(title: "A") {
            self.showPopupInfo("Button A clicked")
        }
        btnMenu.addButton(title: "Bbb") {
            self.showPopupInfo("Button B clicked")
        }
        btnMenu.addButton(title: "Ccc") {
            self.showPopupInfo("Button C clicked")
        }
        self.view.addSubview(btnMenu)
    }
}

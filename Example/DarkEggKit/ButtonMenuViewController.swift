//
//  ButtonMenuViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/03/06.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class ButtonMenuViewController: UIViewController {
    var buttonMenu: DZButtonMenu = DZButtonMenu()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            Logger.debug(self.view.safeAreaInsets)
        }
        
        let config = DZButtonMenuConfiguration.default()
        config.location = .rightBottom
        config.style = .line
        config.direction = .up
        self.buttonMenu = DZButtonMenu(configuration: config)
        self.buttonMenu.addButton(title: "Aaa") {
            self.showPopupInfo("Button Aaa clicked")
        }
        self.buttonMenu.addButton(title: "Bbb") {
            self.showPopupInfo("Button Bbb clicked")
        }
        self.buttonMenu.addButton(title: "Ccc") {
            self.showPopupInfo("Button Ccc clicked")
        }
        self.view.addSubview(self.buttonMenu)
        
        let config1 = DZButtonMenuConfiguration.default()
        config1.location = .leftBottom
        config1.style = .sector
        config1.direction = .up
        let btnMenu = DZButtonMenu(configuration: config1)
        btnMenu.addButton(title: "Aaa") {
            self.showPopupInfo("Button Aaa clicked")
        }
        btnMenu.addButton(title: "Bbb") {
            self.showPopupInfo("Button Bbb clicked")
        }
        btnMenu.addButton(title: "Ccc") {
            self.showPopupInfo("Button Ccc clicked")
        }
        self.view.addSubview(btnMenu)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            Logger.debug(self.view.safeAreaInsets)
        }
        //self.buttonMenu.layoutSubviews()
    }
}

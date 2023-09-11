//
//  SideMenu2ViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2023/09/08.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import DarkEggKit

class SideMenu2ViewController: DZSideMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 16
    }
    
    deinit {
        Logger.debug("Life cycle test - deinit")
    }
}

extension SideMenu2ViewController {
    @IBAction private func onTestButtonClicked(_ sender: UIButton) {
        Logger.debug("Test touch.")
        self.dismiss(animated: true)
    }
}

//
//  MenuViewController.swift
//  DarkEggKit_Example
//
//  Created by darkzero on 2019/03/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
//
import DarkEggKit

class MenuViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.versionLabel.text = DarkEggKit.Common.fullVersionString
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath)
        cell.textLabel?.text = "Menu Item \(indexPath.row)"
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // TODO:
    }
}

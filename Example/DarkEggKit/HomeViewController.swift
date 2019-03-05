//
//  ViewController.swift
//  DarkEggKit
//
//  Created by darkzero on 03/04/2019.
//  Copyright (c) 2019 darkzero. All rights reserved.
//

import UIKit

import DarkEggKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    private var sideMenu: MenuViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenu = (storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController);
        let _ = RGB_HEX("ffffff", 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Common"
        case 1:
            return "Popup Message"
        case 2:
            return "Side Menu"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Color to Image Sample"
        case 1:
            cell.textLabel?.text = "Sample Page"
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Left"
            case 1:
                cell.textLabel?.text = "Right"
            case 2:
                cell.textLabel?.text = "Left Cover"
            case 3:
                cell.textLabel?.text = "Right Cover"
            default:
                cell.textLabel?.text = ""
            }
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //
        switch indexPath.section {
        case 0:
            self.performSegue(withIdentifier: "ShowCommonScene", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "ShowPopupMessageScene", sender: self)
            break
        case 2:
            switch indexPath.row {
            case 0:
                var config = DZSideMenuConfiguration()
                config.position = .left
                config.animationType = .default
                self.dz_showSideMenu(self.sideMenu, configuration: config)
                break
            case 1:
                var config = DZSideMenuConfiguration()
                config.position = .right
                config.animationType = .default
                self.dz_showSideMenu(self.sideMenu, configuration: config)
                break
            case 2:
                var config = DZSideMenuConfiguration()
                config.position = .left
                config.animationType = .cover
                self.dz_showSideMenu(self.sideMenu, configuration: config)
                break
            case 3:
                var config = DZSideMenuConfiguration()
                config.position = .right
                config.animationType = .cover
                self.dz_showSideMenu(self.sideMenu, configuration: config)
                break
            default:
                break
            }
        default:
            self.showPopupWarning("Nothing is here.")
            break
        }
    }
}

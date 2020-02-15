//
//  ViewController.swift
//  DarkEggKit
//
//  Created by darkzero on 03/04/2019.
//  Copyright (c) 2019 darkzero. All rights reserved.
//

import UIKit

import DarkEggKit

fileprivate let menuTable = [
    [
        "section_title": "Common",
        "cells": [
            ["title": "Color to Image Sample"]
        ]
    ]
]

class HomeViewController: UIViewController, DarkEggPopupMessageProtocol {
    @IBOutlet var tableView: UITableView!
    private var sideMenu: MenuViewController!
    
    private var menuTable: [ModuleSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenu = (storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController);
        //let _ = RGB_HEX("ffffff", 1.0)
        
        // TODO:
        SubModuleManager.shared.loadJsonFile { (ret) in
            //Logger.debug(ret)
            guard ret.count > 0 else {
                self.showPopupError("Error in Loading JSON!")
                return
            }
            self.menuTable = ret
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController {
    @IBAction private func onAboutButtonClicked(_ sender: UINavigationItem) {
        if let uv = (storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController) {
            self.navigationController?.pushViewController(uv, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTable[section].cells?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.menuTable[section].section_title ?? "-"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath)
        let title = self.menuTable[indexPath.section].cells?[indexPath.row]?.title ?? "--"
        cell.textLabel?.text = title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let segueId = self.menuTable[indexPath.section].cells?[indexPath.row]?.segue_id {
            self.performSegue(withIdentifier: segueId, sender: self)
        }
        else {
            switch indexPath.section {
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
}

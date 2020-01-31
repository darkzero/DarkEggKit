//
//  AboutViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/09/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class AboutViewController: UIViewController {
    @IBOutlet var aboutTextView: UITextView!
    
    private let aboutFileName: String = "About"
    private let aboutFileExtension: String = "txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "About"
        self.loadAboutText()
    }
}

extension AboutViewController {
    private func loadAboutText() {
        do {
            let attrStr = try getTermString()
            let libVersion = DarkEggKit.Common.bundleDisplayName + "\n" + DarkEggKit.Common.fullVersionString
            let appVersion = Common.bundleDisplayName + "\n" + Common.fullVersionString
            Logger.debug(attrStr)
            self.aboutTextView.text = libVersion + "\n\n" + appVersion + "\n\n" + attrStr
        } catch {
            Logger.error("load txt file failure: \(error.localizedDescription)")
        }
    }
    
    enum FileError: Error {
        case notExitPath
        case faildRead
    }
    
    private func getTermString() throws -> String {
        if let url =  Bundle.main.url(forResource: aboutFileName, withExtension: aboutFileExtension) {
            do {
                let terms = try Data(contentsOf: url)
                if let str = String(data: terms, encoding: String.Encoding.utf8) {
                    return str
                }
                else {
                    throw FileError.faildRead
                }
            } catch let error {
                Logger.error("load txt file failure: \(error.localizedDescription)")
                throw FileError.faildRead
            }
        } else {
            Logger.error("txt file not exist.")
            throw FileError.notExitPath
        }
    }
}

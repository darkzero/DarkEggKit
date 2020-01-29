//
//  AboutViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/09/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

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
            print(attrStr)
            self.aboutTextView.text = attrStr
            //self.aboutTextView.text = "attrStr"
        } catch {
            print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
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
//                let attributeString = try NSAttributedString(data: terms,
//                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
//                                                             documentAttributes: nil)
//                return attributeString
                if let str = String(data: terms, encoding: String.Encoding.utf8) {
                    return str
                }
                else {
                    throw FileError.faildRead
                }
            } catch let error {
                print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
                throw FileError.faildRead
            }
        } else {
            print("aaaa")
            throw FileError.notExitPath
        }
    }
}

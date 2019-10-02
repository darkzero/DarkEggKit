//
//  DarkEggKit.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/09/30.
//

import UIKit

public class Common {
    static public var fullVersionString: String {
        var libVersionString: String = ""
        // version number
        if let infos = Bundle(for: DZUtility.self).infoDictionary,
            let libName = infos[kCFBundleNameKey as String] {
            let shortVersion = (infos["CFBundleShortVersionString"] as? String) ?? "N/A"
            //let libBuildName = infos[kCFBundleVersionKey as String] ?? "N/A"
            //libVersionString = "\(libName) ver \(shortVersion)\nbuild \(libBuildName)"
            libVersionString = "\(libName) ver \(shortVersion)"
        }
        return libVersionString
    }
}

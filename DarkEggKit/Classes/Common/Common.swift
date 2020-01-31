//
//  DarkEggKit.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/09/30.
//

import UIKit

public class Common {
    /// bundle display name
    static public var bundleDisplayName: String {
        if let infos = Bundle(for: Common.self).infoDictionary, let libName = infos[kCFBundleNameKey as String] {
            return "\(libName)"
        }
        return "DarkEggKit"
    }
    
    /// full version string
    /// like: version ??? (build ???)
    static public var fullVersionString: String {
        var libVersionString: String = ""
        // version number
        if let infos = Bundle(for: Common.self).infoDictionary {
            let shortVersion = (infos["CFBundleShortVersionString"] as? String) ?? "N/A"
            let libBuildName = infos[kCFBundleVersionKey as String] ?? "N/A"
            //libVersionString = "\(libName) ver \(shortVersion)\nbuild \(libBuildName)"
            libVersionString = "version \(shortVersion) (build \(libBuildName))"
        }
        return libVersionString
    }
}

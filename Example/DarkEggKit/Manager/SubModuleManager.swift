//
//  SubModuleManager.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/10/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

struct ModuleSection: Codable {
    var section_title: String?
    var cells: [ModuleCell?]?
}

struct ModuleCell: Codable {
    var title: String?
    var segue_id: String?
}

class SubModuleManager: NSObject {
    // MARK: - Properties
    internal var moduleSections: [ModuleSection] = []
    // MARK: - Singleton
    static let shared : SubModuleManager = {SubModuleManager()}()
}

private struct FileInfo {
    var name: String = ""
    var type: String = ""
}

extension SubModuleManager {
    private var jsonFileInfo: FileInfo {
        get {
            return FileInfo(name: "SubModules", type: "json")
        }
    }
    
    /// Load JSON file of submodules table
    /// - Parameter completion: completion handle ()
    internal func loadJsonFile(completion: (([ModuleSection]) -> Void)? ) {
        if let filePath = Bundle.main.path(forResource: jsonFileInfo.name, ofType: jsonFileInfo.type) {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                if let ret = try? decoder.decode([ModuleSection].self, from: jsonData) {
                    completion?(ret)
                }
            } catch {
                // nothing
                completion?([])
            }
        }
    }
}

public class Common {
    /// bundle display name
    static public var bundleDisplayName: String {
        if let infos = Bundle(for: Common.self).infoDictionary, let libName = infos[kCFBundleNameKey as String] {
            return "\(libName)"
        }
        return "DarkEggKit Sample App"
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

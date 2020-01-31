//
//  Logger.swift
//  DarkEggKit/Common
//
//  Created by darkzero on 2019/03/04.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

public class Logger: NSObject {
    /// Print out debug log in console
    ///
    /// - Parameters:
    ///   - msg: the log text
    ///   - file: file name
    ///   - function: function name
    ///   - line: line number
    ///   - column: column number
    public class func debug(_ msg: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        var str = "";
        for i in 0 ..< msg.count {
            str += String(describing: msg[i]);
        }
        print("[DEBUG] \((file as NSString).lastPathComponent) [Line:\(line)] - \(function) : \(str)");
        #endif
    }
    
    /// Print out error log in console
    ///
    /// - Parameters:
    ///   - msg: the log text
    ///   - file: file name
    ///   - function: function name
    ///   - line: line number
    ///   - column: column number
    public class func error(_ msg: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        var str = "";
        for i in 0 ..< msg.count {
            str += String(describing: msg[i]);
        }
        print("[ERROR] \((file as NSString).lastPathComponent) [Line:\(line)] - \(function) : \(str)");
    }
    
}

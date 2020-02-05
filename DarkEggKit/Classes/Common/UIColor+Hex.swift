//
//  UIColor+Hex.swift
//  DarkEggKit/Common
//
//  Created by darkzero on 2019/03/04.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

let MAX_COLOR_RGB:CGFloat   = 255.0;
let DEFAULT_ALPHA:CGFloat   = 1.0;
let RED_MASK_HEX            = 0x10000;
let GREEN_MASK_HEX          = 0x100;

public func RGB(_ r:Int, _ g:Int, _ b:Int) -> UIColor {
    return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:1.0)
}

public func RGBA(_ r:Int, _ g:Int, _ b:Int, _ a:CGFloat) -> UIColor {
    return UIColor.colorWithDec(Red:r, Green:g, Blue:b, Alpha:a)
}

public func RGB_HEX(_ hex:String, _ a:CGFloat) -> UIColor {
    return UIColor.colorWithHex(Hex: hex, Alpha: a)
}

// MARK: - Extension of UIColor
extension UIColor {
    /// Create and return a color object with HEX string (like "3366CC") and alpha (0.0 ~ 1.0)
    ///
    /// - Parameters:
    ///   - hex: HEX string (000000 ~ FFFFFF)
    ///   - alpha: alpha (0.0 ~ 1.0)
    /// - Returns: color
    fileprivate class func colorWithHex( Hex hex:String, Alpha alpha:CGFloat ) -> UIColor {
        let colorScanner:Scanner = Scanner(string: hex);
        var color: uint = 0
        colorScanner.scanHexInt32(&color)
        let r:CGFloat = CGFloat( ( color & 0xFF0000 ) >> 16 ) / 255.0
        let g:CGFloat = CGFloat( ( color & 0x00FF00 ) >> 8 ) / 255.0
        let b:CGFloat = CGFloat( color & 0x0000FF ) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }

    /// Create and return a color object with red, green, blue (0 ~ 255) and alpha (0.0 ~ 1.0)
    ///
    /// - Parameters:
    ///   - r: red (0 ~ 255)
    ///   - g: green (0 ~ 255)
    ///   - b: blue (0 ~ 255)
    ///   - alpha: alpha (0.0 ~ 1.0)
    /// - Returns: color
    fileprivate class func colorWithDec(Red r:Int, Green g:Int, Blue b:Int, Alpha alpha:CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat(r)/MAX_COLOR_RGB,
            green: CGFloat(g)/MAX_COLOR_RGB,
            blue: CGFloat(b)/MAX_COLOR_RGB,
            alpha: alpha
        );
    }
}

extension UIColor {
    /// whiteScale of the color
    /// .white is 1.0
    /// .black is 0.0
    public var whiteScale: CGFloat {
        get {
            var white:CGFloat = 0.0
            self.getWhite(&white, alpha: nil)
            return white
        }
    }
    
    /// grayscale of the color
    /// .white is 0.0
    /// .black is 1.0
    public var grayscale: CGFloat {
        get {
            return 1.0 - self.whiteScale
        }
    }
}

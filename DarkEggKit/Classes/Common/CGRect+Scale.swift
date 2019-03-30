//
//  CGRect+Scale.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/03/31.
//

import UIKit

extension CGRect {
    public func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, y: origin.y * scale,
                      width: size.width * scale, height: size.height * scale)
    }
}

//
//  DZSideMenuConfiguration.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/02.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

let dzScreenWidth = { return UIScreen.main.bounds.width }()

public enum Position {
    case left
    case right
}

public struct DZSideMenuConfiguration {
    public init() {}
    public var distance: Float                 = Float(dzScreenWidth) * Float(0.75)
    public var displayDuration: TimeInterval   = 0.3
    public var hiddenDuration: TimeInterval    = 0.3
    public var maskAlpha: Float                = 0.5
    public var scaleY: Float                   = 1.0
    public var position: Position              = .left
    public var animationType: DZSideMenuTransitioning.AnimationType   = .default
}

//
//  DZSideMenuConfiguration.swift
//  DarkEggKit/SideMenu
//
//  Created by darkzero on 2019/02/02.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

let dzScreenWidth   = { return UIScreen.main.bounds.width }()
let dzScreenHeight  = { return UIScreen.main.bounds.height }()

public enum Position {
    case left
    case right
    case top
    case bottom
}

public enum AnimationType: String {
    case `default`
    case cover
}

public struct DZSideMenuConfiguration {
    public init() {}
    public var sizeScale: Float                = 0.0
    public var displayDuration: TimeInterval   = 0.33
    public var hiddenDuration: TimeInterval    = 0.33
    public var maskAlpha: Float                = 0.45
    public var position: Position              = .left
    public var animationType: AnimationType   = .default
    
    public lazy var distance: Float            = {
        var dis: Float = 0.0
        switch self.position {
        case .left, .right:
            dis = Float(dzScreenWidth) * Float((sizeScale <= 0.0) ? 0.75 : sizeScale)
        case .bottom, .top:
            dis = Float(dzScreenHeight) * Float((sizeScale <= 0.0 ? 0.4 : sizeScale))
        }
        return dis
    }()
}

//
//  DZButtonMenuConfiguration.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/03/07.
//

import UIKit

public class DZButtonMenuConfiguration: NSObject {
    public var location: DZButtonMenu.Location = .rightBottom
    public var direction: DZButtonMenu.Direction = .up
    public var style: DZButtonMenu.Style = .line
    
    public class func `default`() -> DZButtonMenuConfiguration {
        return DZButtonMenuConfiguration()
    }
    
    public init(location: DZButtonMenu.Location = .rightBottom, direction: DZButtonMenu.Direction = .up, style: DZButtonMenu.Style = .line) {
        self.location = location
        self.direction = direction
        self.style = style
        super.init()
    }
}

extension DZButtonMenuConfiguration {
    private func fixDirection(_ direction: DZButtonMenu.Direction, withLocation location: DZButtonMenu.Location) -> DZButtonMenu.Direction {
        var fixedDirection = direction
        switch location {
        case .leftBottom:
            if direction == .left {
                fixedDirection = .right
            }
            else if direction == .down {
                fixedDirection = .up
            }
            break
        case .rightBottom:
            if direction == .right {
                fixedDirection = .left
            }
            else if direction == .down {
                fixedDirection = .up
            }
            break
        default:
            break
        }
        return fixedDirection
    }
    
    internal func adjustDirection() {
        switch self.location {
        case .leftBottom:
            if self.direction == .left {
                self.direction = .right
            }
            else if self.direction == .down {
                self.direction = .up
            }
            break
        case .rightBottom:
            if self.direction == .right {
                self.direction = .left
            }
            else if self.direction == .down {
                self.direction = .up
            }
            break
        case .leftTop:
            break
        case .rightTop:
            break
        default:
            break
        }
    }
}

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
    
    public init(location: DZButtonMenu.Location = .rightBottom, direction: DZButtonMenu.Direction = .up, style: DZButtonMenu.Style = .line) {
        self.location = location
        self.direction = direction
        self.style = style
        // TODO: (next version) adjust direction
    }
    
    public class func `default`() -> DZButtonMenuConfiguration {
        return DZButtonMenuConfiguration()
    }
}

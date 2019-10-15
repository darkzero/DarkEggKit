//
//  DZButtonMenuAttributes.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2019/03/07.
//

import UIKit

public class DZButtonMenuAttributes: NSObject {
    internal var padding: CGFloat = 10.0
    internal var buttonDiameter: CGFloat = 40.0
    internal var buttonPadding: CGFloat = 8.0
    internal var labelHeight: CGFloat = 22.0
    internal var animationDuration: TimeInterval = 0.3
    internal var mainButtonTag: Int {
        get { return 10000 }
    }

    internal var closedColor: UIColor = RGBA(47, 47, 47, 0.7)
    
    private var _initialFrame: CGRect = .zero
    internal var initialFrame: CGRect {
        get {
            return _initialFrame
        }
    }
    
    public class func `default`() -> DZButtonMenuAttributes {
        return DZButtonMenuAttributes()
    }
    
    public override init() {
        if #available(iOS 13, *) {
            closedColor = UIColor.label.withAlphaComponent(0.7)
        }
        else {
            closedColor = RGBA(47, 47, 47, 0.7)
        }
    }
}

extension DZButtonMenuAttributes {
    internal func initialLocation(of index: Int) -> CGPoint {
        let point: CGPoint = .zero
        return point
    }
}


extension DZButtonMenuAttributes {
    internal func mainFrameOf(location: DZButtonMenu.Location, inView: UIView) -> CGRect {
        var rect: CGRect = .zero
        rect.size = CGSize(width: buttonDiameter, height: buttonDiameter)
        if (location.rawValue & 0b001) > 0 {
            rect.origin.x = padding
        }
        else {
            rect.origin.x = inView.frame.size.width - buttonDiameter - padding
        }
        
        if (location.rawValue & 0b010) > 0 {
            let topPadding: CGFloat = DZUtility.safeAreaInsetsOf(inView).top
            rect.origin.y = topPadding + padding
        }
        else {
            let bottomPadding: CGFloat = DZUtility.safeAreaInsetsOf(inView).bottom
            rect.origin.y = inView.frame.size.height - bottomPadding - padding - buttonDiameter
        }
        self._initialFrame = rect
        return rect
    }
    
    internal func openFrameOf(configuration: DZButtonMenuConfiguration, buttonsCount: Int = 1, inView: UIView) -> CGRect {
        var rect: CGRect = .zero
        rect.size = CGSize(width: buttonDiameter, height: buttonDiameter)
        if (configuration.location.rawValue & 0b001) > 0 {
            rect.origin.x = padding
        }
        else {
            rect.origin.x = inView.frame.size.width - buttonDiameter - padding
        }
        
        if (configuration.location.rawValue & 0b010) > 0 {
            let topPadding: CGFloat = { return DZUtility.safeAreaInsetsOf(inView).top }()
            rect.origin.y = topPadding + padding
        }
        else {
            let bottomPadding: CGFloat = { return DZUtility.safeAreaInsetsOf(inView).bottom }()
            rect.origin.y = inView.frame.size.height - bottomPadding - padding - buttonDiameter
        }
        
        let count = CGFloat(buttonsCount)
        switch configuration.direction {
        case .left:
            rect.origin.x = rect.origin.x - (self.buttonDiameter + self.buttonPadding) * count
            rect.size.width = (self.buttonDiameter + self.buttonPadding) * count + self.buttonDiameter
            break
        case .right:
            rect.size.width = (self.buttonDiameter + self.buttonPadding) * count + self.buttonDiameter
            break
        case .up:
            rect.origin.y = rect.origin.y - (self.buttonDiameter + self.buttonPadding) * count
            rect.size.height = (self.buttonDiameter + self.buttonPadding) * count + self.buttonDiameter
            break
        case .down:
            rect.size.height = (self.buttonDiameter + self.buttonPadding) * count + self.buttonDiameter
            break
        }
        
        Logger.debug("location: \(configuration.location), rect: \(rect)")
        return rect
    }
}

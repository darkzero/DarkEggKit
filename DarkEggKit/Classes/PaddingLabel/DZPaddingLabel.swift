//
//  DZPaddingLabel.swift
//  DarkEggKit/Common
//
//  Created by darkzero on 2019/03/01.
//  Copyright © 2019 darkzero. All rights reserved.
//

import UIKit

@IBDesignable
class DZPaddingLabel: UILabel {
    /// Padding
    private var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    /// Top padding
    @IBInspectable var paddingTop: CGFloat {
        get { return self.padding.top }
        set { self.padding.top = newValue }
    }
    /// Left padding
    @IBInspectable var paddingLeft: CGFloat{
        get { return self.padding.left }
        set { self.padding.left = newValue }
    }
    /// Bottom padding
    @IBInspectable var paddingBottom: CGFloat{
        get { return self.padding.bottom }
        set { self.padding.bottom = newValue }
    }
    /// Right padding
    @IBInspectable var paddingRight: CGFloat{
        get { return self.padding.right }
        set { self.padding.right = newValue }
    }
    
    // MARK: - underline
    /// Under line width
    @IBInspectable var underLineWidth: CGFloat = 0.0
    /// Under line color
    @IBInspectable var underLineColor: UIColor = .clear
}

// MARK: - Functions
extension DZPaddingLabel {
    /// drawText
    ///
    /// - Parameter rect: Label frame
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: self.padding)
        super.drawText(in: newRect)
    }
    
    /// Intrinsic ContentSize
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom*2
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    /// draw
    ///
    /// - Parameter rect: Label frame
    override func draw(_ rect: CGRect) {
        // draw underline
        let ctx = UIGraphicsGetCurrentContext();
        ctx?.setStrokeColor(self.underLineColor.cgColor)
        ctx?.setLineWidth(self.underLineWidth)
        ctx?.move(to: CGPoint(x: 0, y: self.bounds.size.height - self.underLineWidth/2))
        ctx?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.underLineWidth/2))
        ctx?.strokePath()
        // super.draw
        super.draw(rect)
    }
}

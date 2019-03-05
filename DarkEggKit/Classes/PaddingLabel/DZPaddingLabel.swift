//
//  PaddingLabel.swift
//  UIUX_iOS_App
//
//  Created by Yuhua Hu on 2019/03/01.
//  Copyright © 2019 Yuhua Hu. All rights reserved.
//

import UIKit

@IBDesignable
class DZPaddingLabel: UILabel {
    // padding
    private var padding: UIEdgeInsets = UIEdgeInsets.zero
    @IBInspectable var paddingTop: CGFloat {
        get { return self.padding.top }
        set { self.padding.top = newValue }
    }
    @IBInspectable var paddingLeft: CGFloat{
        get { return self.padding.left }
        set { self.padding.left = newValue }
    }
    @IBInspectable var paddingBottom: CGFloat{
        get { return self.padding.bottom }
        set { self.padding.bottom = newValue }
    }
    @IBInspectable var paddingRight: CGFloat{
        get { return self.padding.right }
        set { self.padding.right = newValue }
    }
    
    // MARK: - underline
    @IBInspectable var underLineWidth: CGFloat = 0.0
    @IBInspectable var underLineColor: UIColor = .clear
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: self.padding)
        super.drawText(in: newRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom*2
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    override func draw(_ rect: CGRect) {
        // draw underline
        let ctx = UIGraphicsGetCurrentContext();
        ctx?.setStrokeColor(self.underLineColor.cgColor)
        ctx?.setLineWidth(self.underLineWidth)
        ctx?.move(to: CGPoint(x: 0, y: self.bounds.size.height - self.underLineWidth/2))
        ctx?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.underLineWidth/2))
        ctx?.strokePath()
        // draw
        super.draw(rect)
    }
}

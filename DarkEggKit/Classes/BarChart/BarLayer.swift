//
//  BarLayer.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/20.
//

import UIKit

class BarLayer: CAShapeLayer {
    private let bezierPath: UIBezierPath = UIBezierPath()
    
    //
    var config: BarConfiguration = BarConfiguration()
    
    // title: String = ""
    // value: CGFloat = 20.0
    // color: UIColor = .orange
    // textColor: UIColor?
    var item: BarChartItem?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private init(size: CGSize, item: BarChartItem, config: BarConfiguration?) {
        self.item = item
        super.init()
        self.frame.size = size
        self.bezierPath.lineCapStyle = .butt
        self.fillColor = UIColor.clear.cgColor
        if let _config = config {
            self.config = _config
        }
        self.drawPath()
    }
}

extension BarLayer {
    class func create(size: CGSize, item: BarChartItem, config: BarConfiguration) -> BarLayer {
        let layer = BarLayer(size: size, item: item, config: config)
        return layer
    }
    
    internal class func createPath(with size: CGSize, item: BarChartItem, config: BarConfiguration?) -> BarLayer {
        let layer = BarLayer(size: size, item: item, config: config)
        //layer.drawPath()
        return layer
    }
    
    private func drawPath() {
        self.strokeColor = self.config.layer.color.cgColor
        self.lineWidth = self.config.layer.lineWidth
        self.bezierPath.move(to: self.config.animation.startPoint)
        self.bezierPath.addLine(to: self.config.animation.endPoint)
        self.path = self.bezierPath.cgPath
        self.strokeEnd = 0.0
        
        // not draw text this version
        //self.drawText(item?.title ?? "", textSize: 14.0, textColor: self.config.layer.color, direction: config.layer.direction, location: config.layer.textLocation)
    }

    internal func drawText(_ text: String, textSize: CGFloat, textColor: UIColor?, direction: BarDirection, location: BarTextLocation = .head) {
        let textlayer = CATextLayer()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = (direction == .vertical ? .center : .left)
        paragraphStyle.lineBreakMode = .byWordWrapping
        //paragraphStyle.lineSpacing = 3.0
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize),
                     NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let layerSize = NSString(string: text).size(withAttributes: attrs)
        var positionX: CGFloat = 0.0
        var positionY: CGFloat = 0.0;
        var allowableTextWidth = self.config.animation.endPoint.x
        switch (direction, location) {
        case (.horizontal, .head):
            positionX = self.config.animation.startPoint.x + 8
            positionY = config.animation.startPoint.y - lineWidth //+ 16 // - layerSize.height/2
            allowableTextWidth = layerSize.width + 1
            break
        case (.vertical, .head):
            positionX = self.config.animation.startPoint.x - layerSize.width/2
            positionY = self.config.animation.endPoint.y - layerSize.height - 8
            allowableTextWidth = self.config.layer.lineWidth
            break
        case (.horizontal, _):
            positionX = 8.0
            positionY = config.animation.startPoint.y - layerSize.height/2
            allowableTextWidth = self.config.animation.endPoint.x - 16.0
            break
        case (.vertical, .tail):
            positionX = self.config.animation.startPoint.x - layerSize.width/2
            positionY = self.config.animation.startPoint.y + 8
            allowableTextWidth = self.config.layer.lineWidth
            break
// no middle this time, maybe will be added later.
//        case (.horizontal, .middle):
//            positionX = 8.0
//            positionY = config.animation.startPoint.y - layerSize.height/2
//            allowableTextWidth = self.config.animation.endPoint.x - 16.0
//            break
//        case (.vertical, .middle):
//            positionX = self.config.animation.startPoint.x - layerSize.width/2
//            positionY = (self.config.animation.startPoint.y + self.config.animation.endPoint.y)/2 - layerSize.height/2
//            allowableTextWidth = self.config.layer.lineWidth
//            break
        }
        let startPoint = CGPoint(x: positionX, y: positionY)

        if allowableTextWidth > layerSize.width {
            textlayer.font = UIFont.systemFont(ofSize: textSize)
            textlayer.contentsScale = UIScreen.main.scale
            textlayer.frame = CGRect(origin: startPoint, size: CGSize(width: layerSize.width, height: layerSize.height))
            textlayer.fontSize = textSize
            textlayer.alignmentMode = (direction == .vertical ? .center : .left)
            //textlayer.isWrapped = true
            textlayer.truncationMode = .end
            textlayer.backgroundColor = UIColor.clear.cgColor
            textlayer.foregroundColor = textColor?.cgColor ?? ((self.config.layer.color.whiteScale < 0.4) ? UIColor.white.cgColor : UIColor.black.cgColor)
            textlayer.string = text
            
            self.addSublayer(textlayer)
        }
    }
}

extension BarLayer {
    internal func show(animated: Bool = false, completion: (()->Void)?) {
        self.removeAllAnimations()
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?()
            }
            let arcAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            //arcAnimation.beginTime = 0.0
            arcAnimation.fromValue = 0.0
            arcAnimation.toValue  = 1
            arcAnimation.duration = self.config.animation.duration
            arcAnimation.isRemovedOnCompletion = false
            arcAnimation.fillMode = CAMediaTimingFillMode.both
            self.add(arcAnimation, forKey: "DarwPathAnimation")
            
            CATransaction.commit()
        }
        else {
            self.strokeEnd = 1.0
            completion?()
        }
    }
    
    internal func hide(animated: Bool = false, completion: (()->Void)?) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?()
            }
            let revAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            revAnimation.duration = self.config.animation.duration
            revAnimation.fromValue = self.presentation()?.strokeEnd
            revAnimation.toValue = 0.0
            revAnimation.isRemovedOnCompletion = false
            revAnimation.fillMode = CAMediaTimingFillMode.both
            self.removeAllAnimations()
            add(revAnimation, forKey: "HidePathAnimation")
            
            CATransaction.commit()
        }
        else {
            self.strokeEnd = 0.0
            completion?()
        }
    }
}


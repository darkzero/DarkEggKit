//
//  BarLayer.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/20.
//

import UIKit

internal struct BarAnimationConfiguration {
    internal var startPoint: CGPoint = .zero
    internal var endPoint: CGPoint = .zero
    internal var animationDuration: CFTimeInterval = 0.4
    internal var barColor: UIColor = .red
    internal var lineWidth: CGFloat = 2.0
}

class BarLayer: CAShapeLayer {
    private let bezierPath: UIBezierPath = UIBezierPath()
    internal var config: BarAnimationConfiguration = BarAnimationConfiguration()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(size: CGSize, config: BarAnimationConfiguration?) {
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
    internal class func createPath(with size: CGSize, config: BarAnimationConfiguration?) -> BarLayer {
        let layer = BarLayer(size: size, config: config)
        //layer.drawPath()
        return layer
    }
    
    private func drawPath() {
        self.strokeColor = self.config.barColor.cgColor
        self.lineWidth = self.config.lineWidth
        self.bezierPath.move(to: self.config.startPoint)
        self.bezierPath.addLine(to: self.config.endPoint)
        self.path = self.bezierPath.cgPath
        self.strokeEnd = 0.0
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
            arcAnimation.duration = self.config.animationDuration
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
            revAnimation.duration = self.config.animationDuration
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


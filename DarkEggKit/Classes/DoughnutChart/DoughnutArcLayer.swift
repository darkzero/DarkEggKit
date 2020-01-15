//
//  DoughnutArcLayer.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/14.
//

import UIKit

struct ArcAnimationConfiguration {
    internal var startAngle: CGFloat = 0.0
    internal var endAngle: CGFloat = 0.0
    internal var animationDuration: CFTimeInterval = 0.4
    internal var arcColor: UIColor = .red
    internal var lineWidth: CGFloat = 2.0
}

class DoughnutArcLayer: CAShapeLayer {
    private let bezierPath: UIBezierPath = UIBezierPath()
    internal var config: ArcAnimationConfiguration = ArcAnimationConfiguration()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(size: CGSize, config: ArcAnimationConfiguration?) {
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

extension DoughnutArcLayer {
    internal class func createPath(with size: CGSize, config: ArcAnimationConfiguration?) -> DoughnutArcLayer {
        let layer = DoughnutArcLayer(size: size, config: config)
        //layer.drawPath()
        return layer
    }
    
    private func drawPath() {
        let center: CGPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let radius: CGFloat = (self.bounds.width - self.config.lineWidth) / 2
        self.strokeColor = self.config.arcColor.cgColor
        self.bezierPath.addArc(withCenter: center, radius: radius, startAngle: self.config.startAngle, endAngle: self.config.endAngle, clockwise: true)
        self.lineWidth = self.config.lineWidth
        self.path = self.bezierPath.cgPath
        self.strokeEnd = 0.0
    }
}

extension DoughnutArcLayer {
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

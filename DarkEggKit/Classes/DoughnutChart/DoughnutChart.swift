//
//  ProgressBar.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/10.
//

import UIKit

@IBDesignable
public class DoughnutChart: UIView {
    @IBInspectable var inner: CGFloat = 96.0
    @IBInspectable var outer: CGFloat = 128.0 {
        didSet {
            let constraints = [
                self.widthAnchor.constraint(equalToConstant: self.outer),
                self.heightAnchor.constraint(equalToConstant: self.outer)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }
    @IBInspectable var displayWithAnimation: Bool = true
    
    public var data: DoughnutChartData = DoughnutChartData()
    private var layers: [CAShapeLayer] = []
    
    required init?(coder: NSCoder) {
        //self.configuration = DoughnutChartConfiguration()
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        //self.configuration = DoughnutChartConfiguration()
        super.init(frame: frame)
    }
}

extension DoughnutChart {
    public override func draw(_ rect: CGRect) {
        Logger.debug(rect)
        super.draw(rect)
        
        #if TARGET_INTERFACE_BUILDER
        var tempData: DoughnutChartData = DoughnutChartData()
        tempData.maxValue = 100.0
        tempData.arcs.append(DoughnutChartArc(value: 45.0, color: .orange))
        tempData.arcs.append(DoughnutChartArc(value: 35.0, color: .blue))
        tempData.arcs.append(DoughnutChartArc(value: 10.0, color: .lightGray))

        let lineWidth = (outer - inner)/2
        var startAngle = -(CGFloat(Float.pi) / 2)
        for arc in tempData.arcs {
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .butt
            let center: CGPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            let radius: CGFloat = (self.bounds.width - lineWidth) / 2
            let endAngle        = ((arc.value/self.data.maxLength) * 2 * CGFloat(Float.pi)) + startAngle
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
            arc.color.set();
            path.stroke()
            startAngle = endAngle
        }
        #endif
    }
    
    public func showChart(animated: Bool = false, duration: CFTimeInterval) {
        Logger.debug(self.data.maxLength)
        self.layers.removeAll()
        let lineWidth = (outer - inner)/2
        var startAngle = -(CGFloat(Float.pi) / 2)
        
        var beginTime: CFTimeInterval = 0.0
        self.data.arcs.enumerated().forEach { (offset, arc) in
            let arcDuration: CFTimeInterval = duration * CFTimeInterval(arc.value/self.data.maxLength)
            let pathLayer: CAShapeLayer = CAShapeLayer()
            pathLayer.frame.size = self.frame.size
            self.layer.addSublayer(pathLayer)
            self.layers.append(pathLayer)
            
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .butt
            let center: CGPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2);
            let radius: CGFloat = (self.bounds.width - lineWidth) / 2;
            let endAngle        = ((arc.value/self.data.maxLength) * 2 * CGFloat(Float.pi)) + startAngle;
            
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
            pathLayer.strokeColor = arc.color.cgColor
            pathLayer.fillColor = UIColor.clear.cgColor
            pathLayer.lineWidth = lineWidth
            pathLayer.path = path.cgPath
            
            if animated {
                pathLayer.strokeEnd = 0
                
                let alphaAnim = CABasicAnimation(keyPath: "strokeEnd")
                alphaAnim.beginTime = beginTime
                alphaAnim.toValue  = 1
                alphaAnim.duration = arcDuration
                alphaAnim.fillMode = CAMediaTimingFillMode.both

                let group = CAAnimationGroup()
                group.animations = [alphaAnim]
                group.isRemovedOnCompletion = false
                group.duration = duration
                //group.repeatCount = .infinity
                //group.autoreverses = true
                group.fillMode = CAMediaTimingFillMode.both
                pathLayer.add(group, forKey: "DarwPathAnimation")
            }

            beginTime += arcDuration
            startAngle = endAngle
        }
    }
    
    public func clearChart(animated: Bool = false) {
        self.layers.forEach { (layer) in
//            if let ani = layer.animation(forKey: "DarwPathAnimation"), let a = (ani.copy() as? CAAnimationGroup) {
//                a.autoreverses = true
//                //a.speed = -1
//                layer.removeAllAnimations()
//                layer.add(a, forKey: "HidePathAnimation")
//            }

            if animated {
                let revAnimation = CABasicAnimation(keyPath: "strokeEnd")
                revAnimation.duration = 0.4
                revAnimation.fromValue = layer.presentation()?.strokeEnd
                revAnimation.toValue = 0.0
                revAnimation.isRemovedOnCompletion = false
                revAnimation.fillMode = CAMediaTimingFillMode.both
                layer.removeAllAnimations()
                CATransaction.setCompletionBlock {
                    layer.removeFromSuperlayer()
                }
                layer.add(revAnimation, forKey: "HidePathAnimation")
            }
            else {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    private func animateArc(arc: DoughnutChartArc) {
        
    }
}

//
//  ProgressBar.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/10.
//

import UIKit

@IBDesignable
public class DoughnutChart: UIView {
    @IBInspectable var lineWidth: CGFloat = 16.0
    
    public var sortBeforeDisplay: Bool = false
    public var data: DoughnutChartData = DoughnutChartData()
    
    private var layers: [DoughnutArcLayer] = []
    private var inProgress: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

// MARK: - draw (default display in storyboard)
extension DoughnutChart {
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // default display in storyboard
        #if TARGET_INTERFACE_BUILDER
        var tempData: DoughnutChartData = DoughnutChartData()
        tempData.maxValue = 100.0
        tempData.arcs.append(DoughnutChartArc(value: 45.0, color: .systemPink))
        tempData.arcs.append(DoughnutChartArc(value: 35.0, color: .systemOrange))
        tempData.arcs.append(DoughnutChartArc(value: 10.0, color: .lightGray))

        self.lineWidth = min(self.lineWidth, min(self.bounds.width, self.bounds.height)/2)
        var startAngle = -(CGFloat(Float.pi) / 2)
        for arc in tempData.arcs {
            let path = UIBezierPath()
            path.lineWidth = self.lineWidth
            path.lineCapStyle = .butt
            let center: CGPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            let radius: CGFloat = (min(self.bounds.width, self.bounds.height) - self.lineWidth) / 2
            let endAngle        = ((arc.value/self.data.maxLength) * 2 * CGFloat(Float.pi)) + startAngle
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true);
            arc.color.set();
            path.stroke()
            startAngle = endAngle
        }
        #endif
    }
}

// MARK: - show and hide animation functions
extension DoughnutChart {
    /// Animation
    /// - Parameters:
    ///   - animated: animated or not
    ///   - duration: animation duration
    public func showChart(animated: Bool = false, duration: CFTimeInterval) {
        // check&set the in progress flag
        guard !self.inProgress else {
            return
        }
        self.inProgress = true
        
        // clear
        self.layers.forEach { (layer) in
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        self.layers.removeAll()
        
        if self.sortBeforeDisplay {
            self.data.arcs.sort { $0.value > $1.value }
        }
        
        // make animations
        var startAngle = -(CGFloat(Float.pi) / 2)
        self.lineWidth = min(self.lineWidth, min(self.bounds.width, self.bounds.height)/2)
        
        self.data.arcs.enumerated().forEach { (offset, arc) in
            let endAngle = ((arc.value/self.data.maxLength) * 2 * CGFloat(Float.pi)) + startAngle
            let arcDuration: CFTimeInterval = duration * CFTimeInterval(arc.value/self.data.maxLength)

            var config: ArcAnimationConfiguration = ArcAnimationConfiguration()
            config.startAngle = startAngle
            config.endAngle = endAngle
            config.animationDuration = arcDuration
            config.arcColor = arc.color
            config.lineWidth = self.lineWidth
            
            let pathLayer = DoughnutArcLayer.createPath(with: self.frame.size, config: config)
//            if offset == self.data.arcs.count-1 || offset == 0 {
//                pathLayer.lineCap = .round;
//            }
            self.layers.append(pathLayer)
            self.layer.addSublayer(pathLayer)
            
            startAngle = endAngle
        }
        
        // run animation
        self.startShowAnimation(animated: animated, completion: {
            self.inProgress = false
        })
    }
    
    /// Start the animation of display
    /// - Parameters:
    ///   - animated: animated or not
    ///   - index: index of arc
    ///   - completion: callback function
    private func startShowAnimation(animated: Bool = true, index: Int = 0, completion: (()->Void)? = nil) {
        guard index < self.data.arcs.count else {
            completion?()
            return
        }
        self.layers[index].show(animated: animated, completion: {
            self.startShowAnimation(animated: animated, index: index+1, completion: completion)
        })
    }
    
    /// Animation
    /// - Parameters:
    ///   - animated: animated or not
    public func clearChart(animated: Bool = false) {
        guard !self.inProgress else {
            return
        }
        if animated {
            self.inProgress = true
            self.startHideAnimation(animated: animated, completion: {
                self.layers.forEach { (layer) in
                    layer.removeFromSuperlayer()
                }
                self.layers.removeAll()
                self.inProgress = false
            })
        }
        else {
            self.layers.forEach { (layer) in
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
            self.layers.removeAll()
        }
    }
    
    /// Start the animation of clear
    /// - Parameters:
    ///   - animated: animated or not
    ///   - index: index of arc
    ///   - completion: callback function
    private func startHideAnimation(animated: Bool = true, index: Int? = nil, completion: (()->Void)? = nil) {
        var idx: Int = 0
        if index == nil {
            idx = self.layers.count - 1
        }
        else {
            idx = index!
        }
        
        guard idx >= 0 else {
            completion?()
            return
        }
        
        self.layers[idx].hide(animated: animated, completion: {
            self.layers[idx].opacity = 0.0
            self.startHideAnimation(animated: animated, index: idx-1, completion: completion)
        })
    }
}

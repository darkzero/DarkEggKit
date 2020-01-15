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
    private var inProgress: Bool = false
    
    public var data: DoughnutChartData = DoughnutChartData()
    private var layers: [DoughnutArcLayer] = []
    
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
        tempData.arcs.append(DoughnutChartArc(value: 45.0, color: .systemPink))
        tempData.arcs.append(DoughnutChartArc(value: 35.0, color: .systemOrange))
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
        guard !self.inProgress else {
            return
        }
        self.inProgress = true
        
        self.layers.forEach { (layer) in
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
        self.layers.removeAll()
        
        let lineWidth = (outer - inner)/2
        var startAngle = -(CGFloat(Float.pi) / 2)
        
        self.data.arcs.enumerated().forEach { (offset, arc) in
            let endAngle = ((arc.value/self.data.maxLength) * 2 * CGFloat(Float.pi)) + startAngle
            let arcDuration: CFTimeInterval = duration * CFTimeInterval(arc.value/self.data.maxLength)

            var config: ArcAnimationConfiguration = ArcAnimationConfiguration()
            config.startAngle = startAngle
            config.endAngle = endAngle
            config.animationDuration = arcDuration
            config.arcColor = arc.color
            config.lineWidth = lineWidth
            
            let pathLayer = DoughnutArcLayer.createPath(with: self.frame.size, config: config)
            self.layers.append(pathLayer)
            self.layer.addSublayer(pathLayer)
            
            startAngle = endAngle
        }
        
        self.startShowAnimation(animated: animated, completion: {
            self.inProgress = false
        })
    }
    
    private func startShowAnimation(animated: Bool = true, index: Int = 0, completion: (()->Void)? = nil) {
        guard index < self.data.arcs.count else {
            completion?()
            return
        }
        self.layers[index].show(animated: animated, completion: {
            self.startShowAnimation(animated: animated, index: index+1, completion: completion)
        })
    }
    
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
            self.startHideAnimation(animated: animated, index: idx-1, completion: completion)
        })
    }
}

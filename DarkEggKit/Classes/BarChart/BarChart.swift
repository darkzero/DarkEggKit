//
//  BarChart.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/20.
//

import UIKit

enum BarDirection: Int {
    case horizontal = 0
    case vertical = 1
}

public enum BarAnimationType: Int {
    case meantime = 0
    case sequence
}

@IBDesignable
public class BarChart: UIView {
    @IBInspectable var direction: Int = BarDirection.horizontal.rawValue
    @IBInspectable var padding: CGFloat = 8.0
    @IBInspectable var barWidth: CGFloat = 32.0
    public var animationType: BarAnimationType = .sequence
    
    private var inProgress: Bool = false
    
    public var data: BarChartData = BarChartData()
    private var layers: [BarLayer] = []
}

// MARK: - draw (default display in storyboard)
extension BarChart {
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // default display in storyboard
        #if TARGET_INTERFACE_BUILDER
        var tempData = BarChartData()
        tempData.maxValue = 100.0
        tempData.items.append(BarChartItem(value: 45.0, color: .systemPink))
        tempData.items.append(BarChartItem(value: 35.0, color: .systemOrange))
        tempData.items.append(BarChartItem(value: 10.0, color: .lightGray))

        let itemCountF: CGFloat = CGFloat(tempData.items.count)
        var lineWidth: CGFloat = 0.0
        var barLength: CGFloat = 0.0
        switch self.direction {
        case BarDirection.horizontal.rawValue:
            lineWidth = min((self.bounds.height - self.padding * (itemCountF - 1.0)) / itemCountF, barWidth)
            break
        default:
            lineWidth = min((self.bounds.width - self.padding * (itemCountF - 1.0)) / itemCountF, barWidth)
            break
        }
        tempData.items.enumerated().forEach({ (offset, item) in
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .butt
            var startPoint: CGPoint = .zero
            var endPoint: CGPoint = .zero
            switch self.direction {
            case BarDirection.horizontal.rawValue:
                let offsetValue: CGFloat = CGFloat(offset) * (lineWidth + self.padding) + lineWidth/2
                barLength = self.bounds.width/tempData.maxLength*item.value
                startPoint = CGPoint(x: 0.0, y: offsetValue)
                endPoint = CGPoint(x: barLength, y: offsetValue)
                break
            default:
                let offsetValue: CGFloat = CGFloat(offset) * (lineWidth + self.padding) + lineWidth/2
                barLength = self.bounds.height/tempData.maxLength*item.value
                startPoint = CGPoint(x: offsetValue, y: self.bounds.height)
                endPoint = CGPoint(x: offsetValue, y: self.bounds.height - barLength)
                break
            }
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            item.color.set();
            path.stroke()
        })
        #endif
    }
}

// MARK: - show animation functions
extension BarChart {
    /// Animation of show
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
        
        // make animations
        let itemCountF: CGFloat = CGFloat(self.data.items.count)
        var lineWidth: CGFloat = 0.0
        var barLength: CGFloat = 0.0
        switch self.direction {
        case BarDirection.horizontal.rawValue:
            lineWidth = min((self.bounds.height - self.padding * (itemCountF - 1.0)) / itemCountF, barWidth)
            break
        default:
            lineWidth = min((self.bounds.width - self.padding * (itemCountF - 1.0)) / itemCountF, barWidth)
            break
        }
        
        self.data.items.enumerated().forEach { (offset, item) in
            var startPoint: CGPoint = .zero
            var endPoint: CGPoint = .zero
            let arcDuration: CFTimeInterval = duration * CFTimeInterval(item.value/self.data.maxLength)
            switch self.direction {
            case BarDirection.horizontal.rawValue:
                let offsetValue: CGFloat = CGFloat(offset) * (lineWidth + self.padding) + lineWidth/2
                barLength = self.bounds.width/self.data.maxLength*item.value
                startPoint = CGPoint(x: 0.0, y: offsetValue)
                endPoint = CGPoint(x: barLength, y: offsetValue)
                break
            default:
                let offsetValue: CGFloat = CGFloat(offset) * (lineWidth + self.padding) + lineWidth/2
                barLength = self.bounds.height/self.data.maxLength*item.value
                startPoint = CGPoint(x: offsetValue, y: self.bounds.height)
                endPoint = CGPoint(x: offsetValue, y: self.bounds.height - barLength)
                break
            }
            var config: BarAnimationConfiguration = BarAnimationConfiguration()
            config.startPoint = startPoint
            config.endPoint = endPoint
            config.animationDuration = arcDuration
            config.barColor = item.color
            config.lineWidth = lineWidth
            
            let pathLayer = BarLayer.createPath(with: self.frame.size, config: config)
            self.layers.append(pathLayer)
            self.layer.addSublayer(pathLayer)
        }
        
        switch self.animationType {
        case .sequence:
            self.showInSequence(animated: animated, completion: {
                self.inProgress = false
            })
            break
        case .meantime:
            self.showInMeantime(animated: animated, completion: {
                self.inProgress = false
            })
            break
        }
    }
    
    /// Start the animation of display in sequence
    /// - Parameters:
    ///   - animated: animated or not
    ///   - index: index of arc
    ///   - completion: callback function
    private func showInSequence(animated: Bool = true, index: Int = 0, completion: (()->Void)? = nil) {
        guard index < self.data.items.count else {
            completion?()
            return
        }
        self.layers[index].show(animated: animated, completion: {
            self.showInSequence(animated: animated, index: index+1, completion: completion)
        })
    }
    
    /// Start the animation of display in meantime
    /// - Parameters:
    ///   - animated: animated or not
    ///   - index: index of arc
    ///   - completion: callback function
    private func showInMeantime(animated: Bool = true, completion: (()->Void)? = nil) {
        var count = self.layers.count
        for layer in self.layers {
            layer.show(animated: animated, completion:  {
                // nil
                count -= 1
                if count <= 0 {
                    completion?()
                }
            })
        }
    }
}

// MARK: - hide animation functions
extension BarChart {
    /// Animation of hide
    /// - Parameters:
    ///   - animated: animated or not
    public func clearChart(animated: Bool = false) {
        guard !self.inProgress else {
            return
        }
        if animated {
            self.inProgress = true
            switch self.animationType {
            case .sequence:
                self.hideInSequence(animated: animated) {
                    self.layers.forEach { (layer) in
                        layer.removeFromSuperlayer()
                    }
                    self.layers.removeAll()
                    self.inProgress = false
                }
                break
            case .meantime:
                self.hideInMeantime(animated: animated) {
                    self.layers.forEach { (layer) in
                        layer.removeFromSuperlayer()
                    }
                    self.layers.removeAll()
                    self.inProgress = false
                }
                break
            }
        }
        else {
            self.layers.forEach { (layer) in
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
            self.layers.removeAll()
        }
    }
    
    /// Start the animation of clear in sequence
    /// - Parameters:
    ///   - animated: animated or not
    ///   - index: index of bar
    ///   - completion: callback function
    private func hideInSequence(animated: Bool = true, index: Int? = nil, completion: (()->Void)? = nil) {
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
            self.hideInSequence(animated: animated, index: idx-1, completion: completion)
        })
    }
    
    /// Start the animation of clear in meantime
    /// - Parameters:
    ///   - animated: animated or not
    ///   - completion: callback function
    private func hideInMeantime(animated: Bool = true, completion: (()->Void)? = nil) {
        var count = self.layers.count
        for layer in self.layers {
            layer.hide(animated: animated, completion:  {
                // nil
                count -= 1
                if count <= 0 {
                    completion?()
                }
            })
        }
    }
}

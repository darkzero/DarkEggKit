//
//  DoughnutChartConfiguration.swift
//  DarkEggKit
//
//  Created by darkzero on 2020/01/10.
//

import UIKit

func getBackgroundColor() -> UIColor {
    if #available(iOS 13, *) {
        return .systemFill
    }
    else {
        return RGBA(120, 120, 128, 0.2)
    }
}

/// DoughnutChartArc data
/// - value: value of arc
/// - color: color of arc
public struct DoughnutChartArc {
    var value: CGFloat = 20.0
    var color: UIColor = .orange
    
    public init(value: CGFloat, color: UIColor) {
      self.value = value
      self.color = color
    }
}

public struct DoughnutChartData {
    public var maxValue: CGFloat = 100.0
    public var arcs: [DoughnutChartArc] = []
    
    public init() {}
    
    public init(maxValue: CGFloat, arcs: [DoughnutChartArc]) {
        self.maxValue = maxValue
        self.arcs = arcs
    }
    
    internal lazy var maxLength: CGFloat = {
        var sum: CGFloat = 0.0
        arcs.enumerated().forEach { (offset, arc) in
            sum = sum + arc.value
        }
        if sum > self.maxValue {
            return sum
        }
        return self.maxValue
    }()
}

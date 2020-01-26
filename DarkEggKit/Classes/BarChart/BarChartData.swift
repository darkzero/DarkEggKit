//
//  BarChartData.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2020/01/20.
//

import UIKit

/// BarChart item data
/// - value: value of arc
/// - color: color of arc
public struct BarChartItem {
    var value: CGFloat = 20.0
    var color: UIColor = .orange
    
    public init(value: CGFloat, color: UIColor) {
      self.value = value
      self.color = color
    }
}

public struct BarChartData {
    public var maxValue: CGFloat = 100.0
    public var items: [BarChartItem] = []
    
    public init() {}
    
    public init(maxValue: CGFloat, arcs: [BarChartItem]) {
        self.maxValue = maxValue
        self.items = arcs
    }
    
    internal lazy var maxLength: CGFloat = {
        var _maxLength: CGFloat = 0.0
        if let (maxIndex, maxItem) = items.enumerated().max(by: { $0.element.value < $1.element.value }) {
            print("The max element is \(maxValue) at index \(maxIndex)")
            _maxLength = maxItem.value
        }
        return max(_maxLength, self.maxValue)
    }()
}

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
    var title: String = ""
    var value: CGFloat = 20.0
    var color: UIColor = .orange
    var textColor: UIColor?
    
    public init(title: String = "", value: CGFloat, color: UIColor, textColor: UIColor? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.textColor = (textColor != nil) ? textColor : color
    }
}

/// Bar Chart Data
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
            _maxLength = maxItem.value
        }
        return max(_maxLength, self.maxValue)
    }()
}

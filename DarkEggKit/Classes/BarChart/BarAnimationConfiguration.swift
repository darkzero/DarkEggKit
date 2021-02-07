//
//  BarAnimationConfiguration.swift
//  DarkEggKit
//
//  Created by darkzero on 2021/02/03.
//

struct ChartConfiguration {
    var maxLength: CGFloat = 0.0
    var size: CGSize = CGSize.zero
}

struct BarConfiguration {
    var animation: BarAnimationConfiguration = BarAnimationConfiguration()
    var layer: BarLayerConfiguration = BarLayerConfiguration()
}

struct BarAnimationConfiguration {
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    var duration: CFTimeInterval = 0.4
}

struct BarLayerConfiguration {
    var index: Int = 0
    var color: UIColor = .red
    var lineWidth: CGFloat = 2.0
    var direction: BarDirection = .vertical
    var textLocation: BarTextLocation = .head
}

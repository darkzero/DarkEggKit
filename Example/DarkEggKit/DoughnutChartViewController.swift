//
//  DoughnutChartViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2020/01/10.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class DoughnutChartViewController: UIViewController {
    @IBOutlet var dountChart: DoughnutChart!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var data: DoughnutChartData = DoughnutChartData()
        data.maxValue = 100.0
        data.arcs.append(DoughnutChartArc(value: 60.0, color: .orange))
        data.arcs.append(DoughnutChartArc(value: 30.0, color: .systemOrange))
        data.arcs.append(DoughnutChartArc(value: 30.0, color: .lightGray))
        self.dountChart.data = data
        self.dountChart.showChart(animated: false, duration: 2.0)
    }
}

extension DoughnutChartViewController {
    @IBAction func onClearButtonClicked(_ sender: UIButton) {
        self.dountChart.clearChart(animated: true)
    }
    
    @IBAction func onShowButtonClicked(_ sender: UIButton) {
        self.dountChart.clearChart(animated: false)
        var data: DoughnutChartData = DoughnutChartData()
        data.maxValue = 100.0
        data.arcs.append(DoughnutChartArc(value: 45.0, color: .orange))
        data.arcs.append(DoughnutChartArc(value: 35.0, color: .systemOrange))
        data.arcs.append(DoughnutChartArc(value: 10.0, color: .lightGray))
        self.dountChart.data = data
        self.dountChart.showChart(animated: true, duration: 2.0)
    }
}

class TestView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

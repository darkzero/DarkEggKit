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
    
    @IBOutlet var mainSlider: UISlider!
    @IBOutlet var subSlider: UISlider!
    @IBOutlet var otherSlider: UISlider!
    @IBOutlet var mainValueLabel: UILabel!
    @IBOutlet var subValueLabel: UILabel!
    @IBOutlet var otherValueLabel: UILabel!
    @IBOutlet var animationSwitch: UISwitch!
    
    // values
    var mainValue: CGFloat {
        get { return CGFloat(roundf(self.mainSlider.value)) }
    }
    var subValue: CGFloat {
        get { return CGFloat(roundf(self.subSlider.value)) }
    }
    var otherValue: CGFloat {
        get { return CGFloat(roundf(self.otherSlider.value)) }
    }
    var chartAnimated: Bool {
        get { return self.animationSwitch.isOn }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.dountChart.data = self.getData()
        self.dountChart.showChart(animated: chartAnimated, duration: 1.0)
    }
}

// MARK: - Actions
extension DoughnutChartViewController {
    @IBAction func onClearButtonClicked(_ sender: UIButton) {
        self.dountChart.clearChart(animated: chartAnimated)
    }
    
    @IBAction func onShowButtonClicked(_ sender: UIButton) {
        self.dountChart.clearChart(animated: false)
        self.dountChart.data = self.getData()
        self.dountChart.sortBeforeDisplay = true
        self.dountChart.showChart(animated: chartAnimated, duration: 1.0)
    }
    
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let value = roundf(sender.value)
        switch sender {
        case self.mainSlider:
            self.mainValueLabel.text = "\(value)"
        case self.subSlider:
            self.subValueLabel.text = "\(value)"
        case self.otherSlider:
            self.otherValueLabel.text = "\(value)"
        default:
            break
        }
    }
}

// MARK: -
extension DoughnutChartViewController {
    private func getData() -> DoughnutChartData {
        var data: DoughnutChartData = DoughnutChartData()
        data.maxValue = 100.0
        data.arcs.append(DoughnutChartArc(value: mainValue, color: self.mainSlider.thumbTintColor ?? .systemPink))
        data.arcs.append(DoughnutChartArc(value: subValue, color: self.subSlider.thumbTintColor ?? .systemOrange))
        data.arcs.append(DoughnutChartArc(value: otherValue, color: self.otherSlider.thumbTintColor ?? .systemGray))
        return data
    }
}

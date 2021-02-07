//
//  BarChartViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2020/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class BarChartViewController: UIViewController {
    @IBOutlet var barChart: BarChart!
    
    @IBOutlet var mainSlider: UISlider!
    @IBOutlet var subSlider: UISlider!
    @IBOutlet var otherSlider: UISlider!
    @IBOutlet var mainValueLabel: UILabel!
    @IBOutlet var subValueLabel: UILabel!
    @IBOutlet var otherValueLabel: UILabel!
    @IBOutlet var animationSwitch: UISwitch!
    @IBOutlet var animationTypeSegment: UISegmentedControl!
    
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
        self.barChart.data = self.getData()
        self.barChart.animationType = .sequence
        self.barChart.barDirection = .vertical
        self.barChart.barAlign = .left_top
        self.barChart.barWidth = 32.0
        self.barChart.textSize = 16.0
        self.barChart.textLocation = .head
        self.barChart.showChart(animated: chartAnimated, duration: 1.0)
    }
}

// MARK: - Actions
extension BarChartViewController {
    @IBAction func onClearButtonClicked(_ sender: UIButton) {
        self.barChart.clearChart(animated: chartAnimated)
    }
    
    @IBAction func onShowButtonClicked(_ sender: UIButton) {
        self.barChart.clearChart(animated: false)
        self.barChart.data = self.getData()
        self.barChart.sortBeforeDisplay = true
        //self.barChart.barDirection = .horizontal
        self.barChart.showChart(animated: chartAnimated, duration: 1.0)
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
    
    @IBAction private func onAnimationTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.barChart.animationType = .sequence
            break
        case 1:
            self.barChart.animationType = .meantime
            break
        default:
            self.barChart.animationType = .meantime
            break
        }
    }
}

// MARK: -
extension BarChartViewController {
    private func getData() -> BarChartData {
        var data: BarChartData = BarChartData()
        data.maxValue = 100.0
        data.items.append(BarChartItem(title: "Main", value: mainValue, color: self.mainSlider.thumbTintColor ?? .systemPink))
        data.items.append(BarChartItem(title: "Sub", value: subValue, color: self.subSlider.thumbTintColor ?? .systemOrange))
        data.items.append(BarChartItem(title: "Other", value: otherValue, color: self.otherSlider.thumbTintColor ?? .systemGray))
        return data
    }
}

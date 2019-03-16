//
//  CommonViewController.swift
//  DarkEggKit_Example
//
//  Created by darkzero on 2019/03/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class CommonViewController: UIViewController {
    @IBOutlet weak var startHexField: UITextField!
    @IBOutlet weak var endHexField: UITextField!
    @IBOutlet weak var colorView: UIImageView!
    @IBOutlet weak var fillButton: UIButton!
    @IBOutlet weak var gradientVButton: UIButton!
    @IBOutlet weak var gradientHButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CommonViewController {
    @IBAction func onButtonClicked(_ sender: UIButton) {
        switch sender {
        case self.fillButton:
            colorView.image = UIImage.imageWithColor(RGB_HEX(startHexField.text ?? "ffffff", 1.0))
            break
        case self.gradientVButton:
            let image = UIImage.imageWithGradient(colors: RGB_HEX(startHexField.text ?? "ffffff", 1.0).cgColor, RGB_HEX(endHexField.text ?? "ffffff", 1.0).cgColor,
                                                  size: colorView.bounds.size,
                                                  direction: .vertical)
            colorView.image = image
            break
        case self.gradientHButton:
            let image = UIImage.imageWithGradient(colors: RGB_HEX(startHexField.text ?? "ffffff", 1.0).cgColor, RGB_HEX(endHexField.text ?? "ffffff", 1.0).cgColor,
                                                  //size: colorView.bounds.size,
                                                  direction: .horizontal)
            colorView.image = image
            break
        default:
            self.showPopupWarning("Unknow Button.")
        }
    }
}

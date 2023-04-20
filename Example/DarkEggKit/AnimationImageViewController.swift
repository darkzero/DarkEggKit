//
//  AnimatedImageViewController.swift
//  DarkEggKit_Example
//
//  Created by darkzero on 2019/03/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class AnimatedImageViewController: UIViewController {
    @IBOutlet weak var aniImgView_1: AnimatedImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.debug("---- Start ----")
        
        var apng: AnimationImage?
        switch Int.random(in: 0...5) {
        case 0:
            apng = AnimationImage(path: Bundle.main.path(forResource: "elephant", ofType: "png")!)
        case 1:
            apng = AnimationImage(url: "https://flif.info/example-animation/spinfox_50.png")
        case 2:
            apng = AnimationImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        case 3:
            apng = AnimationImage(url: "https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif")
        case 4:
            // image size is 10MB, test the memory usage
            apng = AnimationImage(url: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg")
        case 5:
            apng = AnimationImage(path: Bundle.main.path(forResource: "elephant", ofType: "png")!)
        default:
            apng = AnimationImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQrO3IgpmS5egLUegtsy8URBq1iOb75Yx9g2qTd_kxc8YZOxf_w")
            break
        }
        //apng = AnimationImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQrO3IgpmS5egLUegtsy8URBq1iOb75Yx9g2qTd_kxc8YZOxf_w")
        
        aniImgView_1.contentMode = .scaleAspectFit
        aniImgView_1.repeatMode = .infinite
        aniImgView_1.aImage = apng
        aniImgView_1.delegate = self
        aniImgView_1.willShowProgress = true
        aniImgView_1.playWhenHighlighted = true
        
        Logger.debug("---- End ----")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.aniImgView_1.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.aniImgView_1.delegate = nil
    }
    
    deinit {
        Logger.debug()
        //self.aniImgView_1.clear()
        //self.aniImgView_1.removeFromSuperview()
        //self.aniImgView_1.delegate = nil
        //self.aniImgView_1 = nil
    }
}

// MARK: - AnimatedImageViewDelegate
extension AnimatedImageViewController: AnimatedImageViewDelegate {
    /// the function that be called when the 'AnimatedImageView' has finished each animation loop.
    /// - Parameters:
    ///   - imageView: the AnimatedImageView
    ///   - count: the loop count, start from 1
    func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt) {
         Logger.debug(count)
    }
    
    /// the function that be called when the 'AnimatedImageView' has reached the max repeat count
    /// - Parameters:
    ///   - imageView: the AnimatedImageView
    ///   - didFinishAnimating: nothing
    func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) {
        Logger.debug()
    }
}

// MARK: - Actions
extension AnimatedImageViewController {
    @IBAction func onClearCacheButtonClicked(_ sender: UIButton) {
        AnimatedImageView.clearCache()
    }
    
    @IBAction func onGotoNextButtonClicked(_ sender: UIButton) {
        if let uv = (storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController) {
            self.navigationController?.pushViewController(uv, animated: true)
        }
    }
    
    @IBAction func onImageTapped(_ sender: UITapGestureRecognizer) {
        // Test for highlight image
        self.aniImgView_1.isHighlighted.toggle()
        Logger.debug("onImageTapped, image highlighted: \(self.aniImgView_1.isHighlighted)")
    }
}

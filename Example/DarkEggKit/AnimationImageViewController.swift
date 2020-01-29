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
        var apng: AnimationImage? // = AImage(url: "https://apng.onevcat.com/assets/elephant.png")
        switch Int.random(in: 1...4) {
        case 1:
            apng = AnimationImage(url: "https://flif.info/example-animation/spinfox_50.png")
        case 2:
            apng = AnimationImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        case 3:
            apng = AnimationImage(url: "https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif")
        case 4:
            apng = AnimationImage(url: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg")
        default:
            break
        }
        //apng = AnimationImage(url: "https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif")
        //apng = AnimationImage(url: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg")
        //let apng = AImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        //let apng = AImage(url: "https://www.bram.us/wordpress/wp-content/uploads/2017/06/GenevaDrive.png")
        //let apng = AImage(url: "https://pbs.twimg.com/media/D2pMC1nVAAA2VQn.jpg")
        //let apng = AImage(url: "https://media.tenor.com/images/39fe167bdab90223bcc890bcb067b761/tenor.gif")
        //https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif
        
        aniImgView_1.aImage = apng
        aniImgView_1.repeatMode = .infinite
        aniImgView_1.delegate = self
        aniImgView_1.willShowProgress = true
        
        //aniImgView_1.needsPrescaling = false
        //aniImgView_2.needsPrescaling = false
        //aniImgView_3.needsPrescaling = false
        //aniImgView_4.needsPrescaling = false
        //aniImgView_1.willShowProgress = false
        //aniImgView_1.placeHolder = nil
        //aniImgView_2.willShowProgress = false
        //aniImgView_3.placeHolder = nil
        //aniImgView_2.isHidden = true
        //aniImgView_3.isHidden = true
        //aniImgView_4.isHidden = true
        
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
        self.aniImgView_1.clear()
        self.aniImgView_1.removeFromSuperview()
        self.aniImgView_1.delegate = nil
        self.aniImgView_1 = nil
    }
}

extension AnimatedImageViewController {
    
    override func willMove(toParent parent: UIViewController?) {
        guard let _ = parent else {
            //self.testView.removeFromSuperview()
            //self.testView = nil
            return
        }
    }
}

extension AnimatedImageViewController: AnimatedImageViewDelegate {
//    func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt) {
//        Logger.debug()
//    }
    
    func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) {
        //imageView.removeFromSuperview()
        Logger.debug()
    }
}

extension AnimatedImageViewController {
    @IBAction func onClearCacheButtonClicked(_ sender: UIButton) {
        AnimatedImageView.clearCache()
    }
    
    @IBAction func onGotoNextButtonClicked(_ sender: UIButton) {
        if let uv = (storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController) {
            self.navigationController?.pushViewController(uv, animated: true)
        }
    }
}

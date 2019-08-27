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
    @IBOutlet weak var aniImgView_2: AnimatedImageView!
    @IBOutlet weak var aniImgView_3: AnimatedImageView!
    @IBOutlet weak var aniImgView_4: AnimatedImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //aniImgView.backgroundColor = .white;
        
        //let data = try! Data(contentsOf: URL(fileReferenceLiteralResourceName: "colon_animation.png"))
        //let apng = AImage(data: data)
        
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
        //
        aniImgView_2.aImage = apng
        aniImgView_2.repeatMode = .infinite
        aniImgView_2.delegate = self
        //
        aniImgView_3.aImage = apng
        aniImgView_3.repeatMode = .infinite
        aniImgView_3.delegate = self
        //
        aniImgView_4.aImage = apng
        aniImgView_4.repeatMode = .infinite
        aniImgView_4.delegate = self
        
        //aniImgView_1.needsPrescaling = false
        //aniImgView_2.needsPrescaling = false
        //aniImgView_3.needsPrescaling = false
        //aniImgView_4.needsPrescaling = false
        
        Logger.debug("---- End ----")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    deinit {
    }
}

extension AnimatedImageViewController: AnimatedImageViewDelegate {
//    func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt) {
//        Logger.debug()
//    }
    
    func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) {
        imageView.removeFromSuperview()
        Logger.debug()
    }
}

extension AnimatedImageViewController {
    @IBAction func onClearCacheButtonClicked(_ sender: UIButton) {
        AnimatedImageView.clearCache()
    }
}

//
//  AnimationImageViewController.swift
//  DarkEggKit_Example
//
//  Created by darkzero on 2019/03/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import DarkEggKit

class AnimationImageViewController: UIViewController {
    @IBOutlet weak var aniImgView: AImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        aniImgView.backgroundColor = .white;
        
        //let data = try! Data(contentsOf: URL(fileReferenceLiteralResourceName: "colon_animation.png"))
        //let apng = AImage(data: data)
        
        Logger.debug("Start")
        var apng: AnimationImage? // = AImage(url: "https://apng.onevcat.com/assets/elephant.png")
        switch Int.random(in: 1...4) {
        case 1:
            apng = AnimationImage(url: "http://ics-web.jp/lab-data/140930_apng/images/elephant_apng_zopfli.png")
        case 2:
            apng = AnimationImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        case 3:
            apng = AnimationImage(url: "https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif")
        case 4:
            apng = AnimationImage(url: "https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg")
        default:
            break
        }
        //let apng = AImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        //let apng = AImage(url: "https://www.bram.us/wordpress/wp-content/uploads/2017/06/GenevaDrive.png")
        //let apng = AImage(url: "https://pbs.twimg.com/media/D2pMC1nVAAA2VQn.jpg")
        //let apng = AImage(url: "https://media.tenor.com/images/39fe167bdab90223bcc890bcb067b761/tenor.gif")
        //https://media2.giphy.com/media/xUPGcLbQtBlro61bdm/giphy.gif
        aniImgView.aImage = apng
        //aniImgView.placeHolder = UIImage(named: "")
        aniImgView.repeatMode = .infinite
        aniImgView.delegate = self
        Logger.debug("End")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //aniImgView.clear()
    }
}

extension AnimationImageViewController: AImageViewDelegate {
//    func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt) {
//        Logger.debug()
//    }
    
    func animatedImageViewDidFinishAnimating(_ imageView: AImageView) {
        Logger.debug()
    }
}

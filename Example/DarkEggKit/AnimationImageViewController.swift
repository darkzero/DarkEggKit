//
//  AnimationImageViewController.swift
//  DarkEggKit_Example
//
//  Created by Yuhua Hu on 2019/03/26.
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
        //let apng = AImage(url: "https://apng.onevcat.com/assets/elephant.png")
        let apng = AImage(url: "https://orig00.deviantart.net/df6e/f/2012/287/f/8/i_want_to_be_a_hero__apng_animated__by_tamalesyatole-d5ht8eu.png")
        //let apng = AImage(url: "https://www.bram.us/wordpress/wp-content/uploads/2017/06/GenevaDrive.png")
        //let apng = AImage(url: "https://pbs.twimg.com/media/D2pMC1nVAAA2VQn.jpg")
        //let apng = AImage(url: "https://media.tenor.com/images/39fe167bdab90223bcc890bcb067b761/tenor.gif")
        aniImgView.aImage = apng
        aniImgView.placeHolder = UIImage(named: "")
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

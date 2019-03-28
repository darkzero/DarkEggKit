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
        
        let apng = AImage(url: "https://apng.onevcat.com/assets/elephant.png")
        //let apng = AImage(url: "https://pbs.twimg.com/media/D2pMC1nVAAA2VQn.jpg")
        //let apng = AImage(url: "https://media.tenor.com/images/39fe167bdab90223bcc890bcb067b761/tenor.gif")
        aniImgView.aImage = apng
        //aniImgView.play = true
        aniImgView.repeatMode = .infinite
        aniImgView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //aniImgView.clear()
    }
}

extension AnimationImageViewController: AImageViewDelegate {
    func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt) {
        Logger.debug()
    }
    
    /// Called after the 'AnimatedImageView' has reached the max repeat count.
    ///
    /// - Parameter imageView: The `AnimatedImageView` that is being animated.
    func animatedImageViewDidFinishAnimating(_ imageView: AImageView) {
        Logger.debug()
    }
}

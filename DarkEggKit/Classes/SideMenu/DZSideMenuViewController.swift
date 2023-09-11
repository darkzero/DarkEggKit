//
//  DZSideMenuViewController.swift
//  DarkEggKit
//
//  Created by Yuhua Hu on 2023/09/08.
//

import UIKit

open class DZSideMenuViewController: UIViewController {
    public var location: Position = .bottom
    public var scale: CGFloat = 0.33
    public var enableTapToClose = true
    
    private var isPresenting: Bool = false
    private var tap: UITapGestureRecognizer!
    private var maskView = UIView()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        Logger.debug("LifeCycle Test")
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.onContainerTapped))
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        Logger.debug("LifeCycle Test")
    }
}

extension DZSideMenuViewController {
    @IBAction private func onCloseButtonClicked(_ sender: UIButton) {
        Logger.debug()
        self.dismiss(animated: true)
    }
    
    
    @objc private func onContainerTapped(_ sender: UITapGestureRecognizer) {
        Logger.debug()
        self.dismiss(animated: true)
    }
}

extension DZSideMenuViewController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: !self.isPresenting ? .to : .from),
        let toVC = transitionContext.viewController(forKey: !self.isPresenting ? .from : .to),
        let fromView = fromVC.view,
                let toView = toVC.view else {
            return
        }
        
        var menuSize = UIScreen.main.bounds.height * scale
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        var startFrame = CGRectMake(0, height, width, menuSize)
        var targetFrame = CGRectMake(0, height-menuSize, width, menuSize)
        
        switch self.location {
        case .left:
            menuSize = UIScreen.main.bounds.width * scale
            startFrame = CGRectMake(-1*menuSize, 0, menuSize, height)
            targetFrame = CGRectMake(0, 0, menuSize, height)
            break
        case .right:
            menuSize = UIScreen.main.bounds.width * scale
            startFrame = CGRectMake(width, 0, menuSize, height)
            targetFrame = CGRectMake(width-menuSize, 0, menuSize, height)
            break
        case .top:
            menuSize = UIScreen.main.bounds.height * scale
            startFrame = CGRectMake(0, -1*menuSize, width, menuSize)
            targetFrame = CGRectMake(0, 0, width, menuSize)
            break
        case .bottom:
            menuSize = UIScreen.main.bounds.height * scale
            startFrame = CGRectMake(0, height, width, menuSize)
            targetFrame = CGRectMake(0, height-menuSize, width, menuSize)
            break
        }
        
        if self.isPresenting {
            toView.frame = startFrame
            container.addSubview(toView)
//            self.setOffAnimation(menuVC: toVC as! MenuVC)
        }
        else {
            toView.frame = targetFrame
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        container.removeGestureRecognizer(self.tap)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if self.isPresenting {
//                fromView!.frame = UIScreen.main.bounds
                container.backgroundColor = .systemBackground.withAlphaComponent(0.5)
                toView.frame = targetFrame
//                self.setOnAnimation(menuVC: toVC as! MenuVC)
            }
            else {
                container.backgroundColor = .clear
                toView.frame = startFrame
//                self.setOffAnimation(menuVC: toVC as! MenuVC)
            }
        }, completion: {(finish:Bool) in
            transitionContext.completeTransition(!(transitionContext.transitionWasCancelled))
            if self.isPresenting && self.enableTapToClose {
                //container.insertSubview(toView, belowSubview: toView)
                toVC.view.addGestureRecognizer(UITapGestureRecognizer())
                container.addGestureRecognizer(self.tap)
                //self.maskView.frame = fromVC.view.bounds
                //self.maskView.addGestureRecognizer(self.tap)
                //fromVC.view.addSubview(self.maskView)
            }
            else {
                container.removeGestureRecognizer(self.tap)
                //self.maskView.removeFromSuperview()
            }
        })
    }
}

extension DZSideMenuViewController: UIViewControllerTransitioningDelegate {
    //presented
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Logger.debug()
        self.isPresenting = true
        return self
    }
    
    //dismissed
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Logger.debug()
        self.isPresenting = false
        return self
    }
}

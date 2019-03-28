//
//  AImageView.swift
//  VTuberApp_iOS
//
//  Created by Yuhua Hu on 2018/11/26.
//  Copyright © 2018年 Yuhua Hu. All rights reserved.
//

import UIKit
import ImageIO

#if swift(>=4.2)
let KFRunLoopModeCommon = RunLoop.Mode.common
#else
let KFRunLoopModeCommon = RunLoopMode.commonModes
#endif

/// Protocol of 'AImageViewDelegate'
public protocol AImageViewDelegate: AnyObject {
    
    /// Called after the 'AnimatedImageView' has finished each animation loop.
    ///
    /// - Parameters:
    ///   - imageView: The `AnimatedImageView` that is being animated.
    ///   - count: The looped count.
    func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt)
    
    /// Called after the 'AnimatedImageView' has reached the max repeat count.
    ///
    /// - Parameter imageView: The `AnimatedImageView` that is being animated.
    func animatedImageViewDidFinishAnimating(_ imageView: AImageView)
}

extension AImageViewDelegate {
    public func animatedImageView(_ imageView: AImageView, didPlayAnimationLoops count: UInt) {}
    public func animatedImageViewDidFinishAnimating(_ imageView: AImageView) {}
}

public class AImageView: UIImageView {
    /// Repeat mode
    ///   - once
    ///   - finite
    ///   - infinite
    public enum RepeatMode: Equatable {
        case once
        case finite(_ count: UInt)
        case infinite
        
        public static func ==(lhs: RepeatMode, rhs: RepeatMode) -> Bool {
            switch (lhs, rhs) {
            case let (.finite(l), .finite(r)):
                return l == r
            case (.once, .once),
                 (.infinite, .infinite):
                return true
            case (.once, .finite(let count)),
                 (.finite(let count), .once):
                return count == 1
            case (.once, _),
                 (.infinite, _),
                 (.finite, _):
                return false
            }
        }
    }

    /// Repeat Mode
    public var repeatMode: RepeatMode = .once {
        didSet {
            if oldValue != repeatMode {
                reset()
                setNeedsDisplay()
                self.layer.setNeedsDisplay()
            }
        }
    }
    
    public var finishCallback: ((_: Bool)->Void)?
    public var autoPlay: Bool = true
    public var stopAtLastFrame: Bool = true
    public var framePreloadCount = 10
    public var needsPrescaling = true
    
    public var delegate: AImageViewDelegate?
    
    /// The run loop mode of animation timer
    /// Default is 'RunLoop.Mode.common'
    /// 'RunLoop.Mode.default' will make the animation pause during UIScrollView scrolling
    public var runLoopMode = KFRunLoopModeCommon {
        willSet {
            guard runLoopMode == newValue else { return }
            stopAnimating()
            displayLink.remove(from: .main, forMode: runLoopMode)
            displayLink.add(to: .main, forMode: newValue)
            startAnimating()
        }
    }
    
    /// Proxy object for preventing a reference cycle
    /// between the 'CADDisplayLink' and 'AnimatedImageView'
    class TargetProxy {
        private weak var target: AImageView?
        init(target: AImageView) {
            self.target = target
        }
        @objc func onScreenUpdate() {
            target?.updateFrameIfNeeded()
        }
    }
    
    public var aImage: AImage? {
        didSet {
            if aImage != oldValue {
                reset()
            }
            setNeedsDisplay()
            self.layer.setNeedsDisplay()
        }
    }
    
    // MARK: - Private property
    /// 'Animator' instance that holds the frames of a specific image in memory.
    private var animator: Animator?
    
    // Dispatch queue used for preloading images.
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "cn.darkzero.DarkEggKit.AImageView.preloadQueue")
    }()
    
    // A flag to avoid invalidating the displayLink on deinit if it was never created
    // because displayLink is so lazy.
    private var isDisplayLinkInitialized: Bool = false
    // A display link that keeps calling the 'updateFrame' method on every screen refresh.
    private lazy var displayLink: CADisplayLink = {
        isDisplayLinkInitialized = true
        let displayLink = CADisplayLink(
            target: TargetProxy(target: self), selector: #selector(TargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: runLoopMode)
        displayLink.isPaused = true
        return displayLink
    }()
    
    /* Whether the image is displaying or not */
    public var play: Bool = false
    
    deinit {
        if self.isDisplayLinkInitialized {
            self.displayLink.invalidate()
        }
    }
    
//    private class func image(from source: CGImageSource, at index: Int = 0) -> UIImage? {
//        if let cgImage: CGImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
//            return UIImage(cgImage: cgImage)
//        }
//        return nil
//        //return UIImage(cgImage: CGImageSourceCreateImageAtIndex(source, 0, nil)!)
//    }
    
}

extension AImageView {
    private func updateFrameIfNeeded() {
        guard let animator = animator else {
            return
        }
        
        guard !animator.isFinished else {
            stopAnimating()
            delegate?.animatedImageViewDidFinishAnimating(self)
            return
        }
        
        let duration: CFTimeInterval
        
        // CA based display link is opt-out from ProMotion by default.
        // So the duration and its FPS might not match.
        // See [#718](https://github.com/onevcat/Kingfisher/issues/718)
        // By setting CADisableMinimumFrameDuration to YES in Info.plist may
        // cause the preferredFramesPerSecond being 0
        if displayLink.preferredFramesPerSecond == 0 {
            duration = displayLink.duration
        } else {
            // Some devices (like iPad Pro 10.5) will have a different FPS.
            duration = 1.0 / Double(displayLink.preferredFramesPerSecond)
        }
        
        animator.shouldChangeFrame(with: duration) { [weak self] hasNewFrame in
            if hasNewFrame {
                self?.layer.setNeedsDisplay()
            }
        }
    }
}

extension AImageView {
    override open var isAnimating: Bool {
        if isDisplayLinkInitialized {
            return !displayLink.isPaused
        } else {
            return super.isAnimating
        }
    }
    
    /// Starts the animation.
    override open func startAnimating() {
        guard !isAnimating else { return }
        if animator?.isReachMaxRepeatCount ?? false {
            return
        }
        
        displayLink.isPaused = false
    }
    
    /// Stops the animation.
    override open func stopAnimating() {
        super.stopAnimating()
        if isDisplayLinkInitialized {
            displayLink.isPaused = true
        }
    }
    
    override open func display(_ layer: CALayer) {
        if let currentFrame = animator?.currentFrameImage {
            layer.contents = currentFrame.cgImage
        } else {
            layer.contents = image?.cgImage
        }
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        didMove()
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        didMove()
    }
    
    override open func willMove(toWindow newWindow: UIWindow?) {
        Logger.debug(newWindow)
        guard let _ = newWindow else {
            self.clear()
            return
        }
    }
    
    private func didMove() {
        if self.autoPlay && animator != nil {
            if let _ = superview, let _ = window {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    
    // Reset the animator.
    private func reset() {
        animator = nil
        if let imageSource = self.aImage?.imageSource {
            let targetSize = bounds.scaled(UIScreen.main.scale).size
            let animator = Animator(
                imageSource: imageSource,
                contentMode: contentMode,
                size: targetSize,
                framePreloadCount: framePreloadCount,
                repeatMode: self.repeatMode,
                preloadQueue: preloadQueue)
            animator.delegate = self
            animator.needsPrescaling = needsPrescaling
            animator.prepareFramesAsynchronously()
            self.animator = animator
        }
        didMove()
    }
    
    public func clear() {
        self.aImage = nil
        self.reset()
    }
}

extension CGRect {
    func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, y: origin.y * scale,
                      width: size.width * scale, height: size.height * scale)
    }
}

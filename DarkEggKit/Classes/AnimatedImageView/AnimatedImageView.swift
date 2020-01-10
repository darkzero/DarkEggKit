//
//  AImageView.swift
//  VTuberApp_iOS
//
//  Created by darkzero on 2018/11/26.
//  Copyright © 2018年 darkzero. All rights reserved.
//

import UIKit
import ImageIO

#if swift(>=4.2)
let kFRunLoopModeCommon = RunLoop.Mode.common
#else
let kFRunLoopModeCommon = RunLoopMode.commonModes
#endif

private let placeHolderName = "darkegg_image_place_holder"

/// Protocol of 'AnimatedImageViewDelegate'
public protocol AnimatedImageViewDelegate: AnyObject {
    /// Called after the 'AnimatedImageView' has finished each animation loop.
    /// - Parameters
    ///   - imageView: The 'AnimatedImageView' that is being animated
    ///   - count: The looped count
    func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt)
    
    /// Called after the 'AnimatedImageView' has reached the max repeat count
    /// - Parameter imageView: The 'AnimatedImageView' that is being animated
    func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void)
}

extension AnimatedImageViewDelegate {
    public func animatedImageView(_ imageView: AnimatedImageView, didPlayAnimationLoops count: UInt) {}
    public func animatedImageView(_ imageView: AnimatedImageView, didFinishAnimating: Void) {}
}

public class AnimatedImageView: UIImageView {
    /// Repeat mode
    ///   - once
    ///   - finite(with count)
    ///   - infinite
    public enum RepeatMode: Equatable {
        case once
        case finite(_ count: UInt)
        case infinite
        
        /// Equatable '=='
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

    /// Repeat Mode (default is infinite)
    public var repeatMode: RepeatMode = .infinite {
        didSet {
            if oldValue != repeatMode {
                self.reset()
                self.setNeedsDisplay()
                self.layer.setNeedsDisplay()
            }
        }
    }
    /// auto start animation (default is True)
    public var autoPlay: Bool = true
    /// preload frame count
    public var framePreloadCount = 10
    /// pre scaling
    public var needsPrescaling = true
    public weak var delegate: AnimatedImageViewDelegate?
    
    private var downloadCancelToken: SessionDataTask.CancelToken = -1
    
    private var progressLayer = CAShapeLayer()
    
    public var placeHolder: UIImage? = UIImage(named: placeHolderName, in: Bundle(for: AnimatedImageView.self), compatibleWith: nil)
    public var willShowProgress: Bool = true
    
    /// The run loop mode of animation timer
    /// Default is 'RunLoop.Mode.common'
    /// 'RunLoop.Mode.default' will make the animation pause during UIScrollView scrolling
    public var runLoopMode = kFRunLoopModeCommon {
        willSet {
            guard runLoopMode == newValue else { return }
            self.stopAnimating()
            self.displayLink.remove(from: .main, forMode: runLoopMode)
            self.displayLink.add(to: .main, forMode: newValue)
            self.startAnimating()
        }
    }
    
    /// Proxy object for preventing a reference cycle
    /// between the 'CADDisplayLink' and 'AnimatedImageView'
    class TargetProxy {
        private weak var target: AnimatedImageView?
        init(target: AnimatedImageView) {
            self.target = target
        }
        @objc func onScreenUpdate() {
            target?.updateFrameIfNeeded()
        }
    }
    
    /// AImage
    public var aImage: AnimationImage? {
        didSet {
            if aImage != oldValue {
                self.downloadCancelToken = aImage?.startLoad(completion: { [weak self] (result, aImage) in
                    if result {
                        DispatchQueue.main.async {
                            self?.progressLayer.removeFromSuperlayer()
                            self?.reset()
                            self?.setNeedsDisplay()
                            self?.layer.setNeedsDisplay()
                        }
                    }
                }, progress: { [weak self] (precent) in
                    self?.showDownloadProgress(precent: precent)
                }) ?? -1
                self.reset()
            }
            self.setNeedsDisplay()
            self.layer.setNeedsDisplay()
        }
    }
    
    // MARK: - Private property
    /// 'Animator' instance that holds the frames of a specific image in memory.
    private var animator: Animator?
    
    // Dispatch queue used for preloading images.
    private lazy var preloadQueue: DispatchQueue = {
        return DispatchQueue(label: "cn.darkzero.DarkEggKit.AnimatedImageView.preloadQueue")
    }()
    
    // A flag to avoid invalidating the displayLink on deinit if it was never created
    // because displayLink is so lazy.
    private var isDisplayLinkInitialized: Bool = false
    // A display link that keeps calling the 'updateFrame' method on every screen refresh.
    private lazy var displayLink: CADisplayLink = {
        isDisplayLinkInitialized = true
        let displayLink = CADisplayLink(target: TargetProxy(target: self), selector: #selector(TargetProxy.onScreenUpdate))
        displayLink.add(to: .main, forMode: runLoopMode)
        displayLink.isPaused = true
        return displayLink
    }()
    
    /* Whether the image is displaying or not */
    public var play: Bool = false
    
    deinit {
        self.aImage = nil
        if self.isDisplayLinkInitialized {
            self.displayLink.invalidate()
        }
    }
}

// MARK: AnimatedImageView Life Cyele
extension AnimatedImageView {
    /// Clear data when disappear, free the memory
    override open func willMove(toWindow newWindow: UIWindow?) {
        guard let _ = newWindow else {
            //self.clear()
            return
        }
        //self.reset()
        //self.startAnimating()
    }
    
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        didMove()
    }
}

extension AnimatedImageView {
    private func updateFrameIfNeeded() {
        guard let animator = animator else {
            return
        }
        // If finished
        // call finish callback
        guard !animator.isFinished else {
            stopAnimating()
            delegate?.animatedImageView(self, didFinishAnimating: ())
            return
        }
        let duration: CFTimeInterval
        if displayLink.preferredFramesPerSecond == 0 {
            duration = displayLink.duration
        } else {
            // Some devices may have different FPS.
            duration = 1.0 / Double(displayLink.preferredFramesPerSecond)
        }
        
        animator.shouldChangeFrame(with: duration) { [weak self] hasNewFrame in
            if hasNewFrame {
                self?.layer.setNeedsDisplay()
            }
        }
    }
}

extension AnimatedImageView {
    override open var isAnimating: Bool {
        if isDisplayLinkInitialized {
            return !displayLink.isPaused
        } else {
            return super.isAnimating
        }
    }
    
    /// Start the animation.
    override open func startAnimating() {
        guard !isAnimating else { return }
        if animator?.isReachMaxRepeatCount ?? false {
            return
        }
        displayLink.isPaused = false
    }
    
    /// Stop the animation.
    override open func stopAnimating() {
        super.stopAnimating()
        //self.animator?.resetAnimatedFrames()
        if isDisplayLinkInitialized {
            displayLink.isPaused = true
        }
    }
    
    override open func display(_ layer: CALayer) {
        if let currentFrame = animator?.currentFrameImage {
            layer.contents = currentFrame.cgImage
        } else {
            //layer.contents = self.placeHolder?.cgImage
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
    
    /// Reset the animator.
    private func reset() {
        animator = nil
        if let aImg = self.aImage, let imageSource = aImg.imageSource {
            let targetSize = self.bounds.size //bounds.scaled(UIScreen.main.scale).size
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
        self.animator?.resetAnimatedFrames()
        self.animator = nil
        self.reset()
    }
}

extension AnimatedImageView {
    public func cancelDownloading() {
        self.aImage?.cancelLoad(token: self.downloadCancelToken)
        self.progressLayer.removeFromSuperlayer()
    }
}

extension AnimatedImageView {
    internal func showDownloadProgress(precent: Float) {
        // show placeholder image
        DispatchQueue.main.async {
            self.layer.contents = self.placeHolder?.cgImage
        }
        // return when willShowProgress if false
        guard self.willShowProgress else {
            return
        }
        // show progress
        DispatchQueue.main.async {
            let width = max(min(self.bounds.width, self.bounds.height)/2.0, 40.0)
            let processPath = UIBezierPath();
            processPath.lineCapStyle    = CGLineCap.round;
            let radius: CGFloat = width*0.75;
            let startAngle              = -(Float.pi) / 2;
            let endAngle                = (precent * 2 * Float.pi) + startAngle;
            let center = CGPoint(x: self.progressLayer.bounds.midX, y: self.progressLayer.bounds.midY)
            
            if self.progressLayer.superlayer == nil, self.progressLayer.frame.width == 0 {
                self.progressLayer.frame = CGRect(origin: CGPoint(x: (self.bounds.width-width)/2, y: (self.bounds.height-width)/2),
                                                  size: CGSize(width: width, height: width))
                self.progressLayer.strokeColor = UIColor.white.cgColor
                self.progressLayer.cornerRadius = 8.0
                self.progressLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor
                self.progressLayer.fillColor = UIColor.clear.cgColor
                self.progressLayer.lineWidth = 6
                self.progressLayer.lineCap = .round
                self.layer.addSublayer(self.progressLayer)
            }
            
            processPath.move(to: CGPoint(x: self.progressLayer.bounds.midX,
                                         y: (self.progressLayer.bounds.height-radius)/2))
            processPath.addArc(withCenter: center,
                               radius: radius/2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true);
            self.progressLayer.path = processPath.cgPath
        }
    }
}

// MARK: - Class function for test
extension AnimatedImageView {
    public class func clearCache() {
        SourceCache.default.clear()
    }
}

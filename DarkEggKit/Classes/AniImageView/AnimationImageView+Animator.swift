//
//  AImageView+Animator.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/03/28.
//

import UIKit


protocol AnimatorDelegate: AnyObject {
    func animator(_ animator: AnimationImageView.Animator, didPlayAnimationLoops count: UInt)
}

extension AnimationImageView: AnimatorDelegate {
    func animator(_ animator: Animator, didPlayAnimationLoops count: UInt) {
        delegate?.animatedImageView(self, didPlayAnimationLoops: count)
    }
}

extension AnimationImageView {
    
    // Represents a single frame in a GIF.
    struct AnimatedFrame {
        
        // The image to display for this frame. Its value is nil when the frame is removed from the buffer.
        let image: UIImage?
        
        // The duration that this frame should remain active.
        let duration: TimeInterval
        
        // A placeholder frame with no image assigned.
        // Used to replace frames that are no longer needed in the animation.
        var placeholderFrame: AnimatedFrame {
            return AnimatedFrame(image: nil, duration: duration)
        }
        
        // Whether this frame instance contains an image or not.
        var isPlaceholder: Bool {
            return image == nil
        }
        
        // Returns a new instance from an optional image.
        //
        // - parameter image: An optional `UIImage` instance to be assigned to the new frame.
        // - returns: An `AnimatedFrame` instance.
        func makeAnimatedFrame(image: UIImage?) -> AnimatedFrame {
            return AnimatedFrame(image: image, duration: duration)
        }
    }
}

extension AnimationImageView {
    // MARK: - Animator
    class Animator {
        private let size: CGSize
        private let maxFrameCount: Int
        private let imageSource: CGImageSource
        private let repeatMode: RepeatMode
        private let maxTimeStep: TimeInterval = 1.0
        private var animatedFrames = [AnimatedFrame]()
        private var frameCount = 0
        private var timeSinceLastFrameChange: TimeInterval = 0.0
        private var currentRepeatCount: UInt = 0
        
        var isFinished: Bool = false
        
        var needsPrescaling = true
        weak var delegate: AnimatorDelegate?
        
        // Total duration of one animation loop
        var loopDuration: TimeInterval = 0
        
        // Current active frame image
        var currentFrameImage: UIImage? {
            return frame(at: currentFrameIndex)
        }
        
        // Current active frame duration
        var currentFrameDuration: TimeInterval {
            return duration(at: currentFrameIndex)
        }
        
        // The index of the current GIF frame.
        var currentFrameIndex = 0 {
            didSet {
                previousFrameIndex = oldValue
            }
        }
        
        var previousFrameIndex = 0 {
            didSet {
                preloadQueue.async {
                    self.updatePreloadedFrames()
                }
            }
        }
        
        var isReachMaxRepeatCount: Bool {
            switch repeatMode {
            case .once:
                return currentRepeatCount >= 1
            case .finite(let maxCount):
                return currentRepeatCount >= maxCount
            case .infinite:
                return false
            }
        }
        
        var isLastFrame: Bool {
            return currentFrameIndex == frameCount - 1
        }
        
        var preloadingIsNeeded: Bool {
            return maxFrameCount < frameCount - 1
        }
        
        var contentMode = UIView.ContentMode.scaleToFill
        
        private lazy var preloadQueue: DispatchQueue = {
            return DispatchQueue(label: "cn.darkzero.DarkEggKit.AImageView.preloadQueue")
        }()
        
        /// Creates an animator with image source reference.
        ///
        /// - Parameters:
        ///   - source: The reference of animated image.
        ///   - mode: Content mode of the `AnimatedImageView`.
        ///   - size: Size of the `AnimatedImageView`.
        ///   - count: Count of frames needed to be preloaded.
        ///   - repeatCount: The repeat count should this animator uses.
        init(imageSource source: CGImageSource,
             contentMode mode: UIView.ContentMode,
             size: CGSize,
             framePreloadCount count: Int,
             repeatMode: RepeatMode,
             preloadQueue: DispatchQueue) {
            self.imageSource = source
            self.contentMode = mode
            self.size = size
            self.maxFrameCount = count
            self.repeatMode = repeatMode
            self.preloadQueue = preloadQueue
        }
        
        func frame(at index: Int) -> UIImage? {
            return animatedFrames[safe: index]?.image
        }
        
        func duration(at index: Int) -> TimeInterval {
            return animatedFrames[safe: index]?.duration  ?? .infinity
        }
        
        func prepareFramesAsynchronously() {
            frameCount = Int(CGImageSourceGetCount(imageSource))
            animatedFrames.reserveCapacity(frameCount)
            preloadQueue.async { [weak self] in
                self?.setupAnimatedFrames()
            }
        }
        
        func shouldChangeFrame(with duration: CFTimeInterval, handler: (Bool) -> Void) {
            incrementTimeSinceLastFrameChange(with: duration)
            if currentFrameDuration > timeSinceLastFrameChange {
                handler(false)
            } else {
                resetTimeSinceLastFrameChange()
                incrementCurrentFrameIndex()
                handler(true)
            }
        }
        
        private func setupAnimatedFrames() {
            resetAnimatedFrames()
            
            var duration: TimeInterval = 0
            
            (0..<frameCount).forEach { index in
                let frameDuration = AnimationImage.getFrameDuration(from: imageSource, at: index)
                duration += min(frameDuration, maxTimeStep)
                animatedFrames += [AnimatedFrame(image: nil, duration: frameDuration)]
                
                if index > maxFrameCount { return }
                animatedFrames[index] = animatedFrames[index].makeAnimatedFrame(image: loadFrame(at: index))
            }
            
            self.loopDuration = duration
        }
        
        private func resetAnimatedFrames() {
            animatedFrames = []
        }
        
        private func loadFrame(at index: Int) -> UIImage? {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else {
                return nil
            }
            return UIImage(cgImage: image)
            
//            let scaledImage: CGImage
//            if needsPrescaling, size != .zero {
//                scaledImage = image.resize(to: size, for: contentMode)
//            } else {
//                scaledImage = image
//            }
//
//            return UIImage(cgImage: scaledImage)
        }
        
        private func updatePreloadedFrames() {
            guard preloadingIsNeeded else {
                return
            }
            
            animatedFrames[previousFrameIndex] = animatedFrames[previousFrameIndex].placeholderFrame
            
            preloadIndexes(start: currentFrameIndex).forEach { index in
                let currentAnimatedFrame = animatedFrames[index]
                if !currentAnimatedFrame.isPlaceholder { return }
                animatedFrames[index] = currentAnimatedFrame.makeAnimatedFrame(image: loadFrame(at: index))
            }
        }
        
        private func incrementCurrentFrameIndex() {
            if isReachMaxRepeatCount && isLastFrame {
                isFinished = true
            } else if currentFrameIndex == 0 {
                currentRepeatCount += 1
                delegate?.animator(self, didPlayAnimationLoops: currentRepeatCount)
            }
            currentFrameIndex = increment(frameIndex: currentFrameIndex)
        }
        
        private func incrementTimeSinceLastFrameChange(with duration: TimeInterval) {
            timeSinceLastFrameChange += min(maxTimeStep, duration)
        }
        
        private func resetTimeSinceLastFrameChange() {
            timeSinceLastFrameChange -= currentFrameDuration
        }
        
        private func increment(frameIndex: Int, by value: Int = 1) -> Int {
            return (frameIndex + value) % frameCount
        }
        
        private func preloadIndexes(start index: Int) -> [Int] {
            let nextIndex = increment(frameIndex: index)
            let lastIndex = increment(frameIndex: index, by: maxFrameCount)
            
            if lastIndex >= nextIndex {
                return [Int](nextIndex...lastIndex)
            } else {
                return [Int](nextIndex..<frameCount) + [Int](0...lastIndex)
            }
        }
    }
}

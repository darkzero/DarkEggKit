//
//  AImage.swift
//  VTuberApp_iOS
//
//  Created by Yuhua Hu on 2018/11/26.
//  Copyright © 2018年 Yuhua Hu. All rights reserved.
//

import ImageIO
import UIKit

public class AImage: NSObject {
    internal let imageSource: CGImageSource
    //internal var framePerSecond:Int
    //internal var displayIndex:[Int]
    public var loopCount:Int
    //static var cache = AniImageCache.default
    
    /* Create an 'AImage' from URL */
    //quality: display quality, 1 is best, 0 is worst
    //loop: display time, -1 means forever
    public convenience init?(url: URL, quality: Float = 1.0, loop: Int = -1) {
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil),
            CGImageSourceGetCount(src) > 0 else {
            return nil
        }
        Logger.debug("success")
        self.init(source: src, quality, loop)
    }
    
    public convenience init?(url: String, quality: Float = 1.0, loop: Int = -1) {
        ///AniImageCache.default.loadImage(from: url)
        guard let src = AniImageCache.default.loadImage(from: url) else {
            return nil
        }
        self.init(source: src, quality, loop)
    }
    
    /* Create an 'AImage' from Data */
    //quality: display quality, 1 is best, 0 is worst
    //loop: display time, -1 means forever
    public convenience init?(data: Data, quality: Float = 1.0, loop: Int = -1) {
        guard let src = CGImageSourceCreateWithData(data as CFData, nil),
            CGImageSourceGetCount(src) > 0 else {
                return nil
        }
        self.init(source: src, quality, loop)
    }
    
    private init(source: CGImageSource, _ quality: Float, _ loop: Int) {
        self.imageSource = source
        //var frameDelays: [Float] = AImage.calcuDelayTimes(imageSource:source)
        //(self.framePerSecond,self.displayIndex) = AImage.calculateFrameDelay(&frameDelays, quality)
        self.loopCount = loop
    }
    
//    private class func calcuDelayTimes(imageSource: CGImageSource) -> [Float] {
//        let frameCount: Int = CGImageSourceGetCount(imageSource)
//        if frameCount <= 1 {
//            return [0]
//        }
//        var imageProperties = [CFDictionary]()
//        for i in 0..<frameCount {
//            imageProperties.append(CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)!)
//        }
//
//        var frameProperties = [CFDictionary]()
//        if (CFDictionaryContainsKey(imageProperties[1], Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque())) {
//            frameProperties = imageProperties.map() {
//                unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
//            } // gif
//        } else if (CFDictionaryContainsKey(imageProperties[1], Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque())) {
//            frameProperties = imageProperties.map() {
//                unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyPNGDictionary).toOpaque()),to: CFDictionary.self)
//            } // apng
//        } else {
//            fatalError("Illegal image type.")
//        }
//
//        let frameDelays: [Float] = frameProperties.map() {
//            var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
//            if (delayObject.floatValue == 0.0){
//                delayObject = unsafeBitCast(CFDictionaryGetValue($0, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
//            }
//            return delayObject.floatValue as Float
//        }
//        return frameDelays
//    }
//
//    private class func calculateFrameDelay(_ delays: inout [Float],_ quality: Float) -> (Int,[Int]) {
//        let framePerSecondChoices = [1,2,3,4,5,6,10,12,15,20,30,60]
//        let displayRefreshDelayTime: [Float] = framePerSecondChoices.map{ 1.0 / Float($0) }
//        for i in 1..<delays.count {
//            delays[i] += delays[i-1]
//        }
//
//        var order = [Int]()
//        var fps: Int = framePerSecondChoices.last!
//        for i in 0..<framePerSecondChoices.count {
//            let displayPosition = delays.map{ Int($0 / displayRefreshDelayTime[i]) }
//            var framelosecount = 0
//            for j in 1..<displayPosition.count {
//                if (displayPosition[j] == displayPosition[j-1])
//                {framelosecount += 1}
//            }
//            if (Float(framelosecount) <= Float(displayPosition.count) * (1 - quality) || i == displayRefreshDelayTime.count - 1) {
//                fps = framePerSecondChoices[i]
//                var indexOfold = 0, indexOfnew = 1
//                while (indexOfnew <= displayPosition.last!) {
//                    if (indexOfnew <= displayPosition[indexOfold]) {
//                        order.append(indexOfold)
//                        indexOfnew += 1
//                    } else {
//                        indexOfold += 1
//                    }
//                }
//                break
//            }
//        }
//        return (fps,order)
//    }
    
    internal class func getFrameDuration(from imageSource: CGImageSource, at idx: Int) -> TimeInterval {
        guard let property = CGImageSourceCopyPropertiesAtIndex(imageSource, idx, nil) as? [String: Any] else {
            return 0.0
        }
        let defaultDuration: TimeInterval = 0.1
        var aniInfo: [String: Any]?
        
        if property[kCGImagePropertyGIFDictionary as String] as? [String: Any] != nil {         // gif
            aniInfo = property[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        }
        else if property[kCGImagePropertyPNGDictionary as String] as? [String: Any] != nil {    // png
            aniInfo = property[kCGImagePropertyPNGDictionary as String] as? [String: Any]
        }
        else {
            return defaultDuration
        }
        
        guard let gifInfo = aniInfo else {
            return defaultDuration
        }
        
        let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
        let duration = unclampedDelayTime ?? delayTime
        
        guard let frameDuration = duration else {
            return defaultDuration
        }
        return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : defaultDuration
    }
}

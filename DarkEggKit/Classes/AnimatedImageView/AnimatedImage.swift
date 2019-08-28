//
//  AImage.swift
//  VTuberApp_iOS
//
//  Created by darkzero on 2018/11/26.
//  Copyright © 2018年 darkzero. All rights reserved.
//

import ImageIO
import UIKit

public class AnimationImage: NSObject {
    private let urlString: String
    internal var imageSource: CGImageSource?
    
    public static func ==(l: AnimationImage, r: AnimationImage) -> Bool {
        return l.urlString == r.urlString
    }
    
    public convenience init?(url: String) {
        // if already in cache
        if let src = SourceCache.default.findSource(from: url) {
            self.init(source: src, urlStr: url)
        } else {
            self.init(urlStr: url)
        }
    }
    
    private init(source: CGImageSource? = nil, urlStr: String) {
        self.imageSource = source
        self.urlString = urlStr
        super.init()
        //self.delegate?.animationImage(self, loadSuccess: true)
    }
    
    deinit {
        self.imageSource = nil
    }
}

// MARK: - Load Task
extension AnimationImage {
    internal func startLoad(completion: ((Bool, AnimationImage)->Void)?, progress: ((Float)->Void)? = nil) -> SessionDataTask.CancelToken {
        guard self.imageSource == nil else {
            return -1
        }
        // completion handle
        let onCompleted = { (result: DownloadResult) -> Void in
            switch result {
            case .success(let src):
                self.imageSource = src
                SourceCache.default.add(url: self.urlString, source: src)
                SourceDownloader.default.releaseTask(url: self.urlString)
                completion?(true, self)
                break
            case .failure:
                completion?(false, self)
                break
            }
        }
        // progress handle
        let onProgress = { (precent: Float)->Void in
            progress?(precent)
        }
        let cancelToken = SourceDownloader.default.downloadImage(from: self.urlString, completion: onCompleted, progress: onProgress)
        return cancelToken
    }
    
    internal func cancelLoad(token: SessionDataTask.CancelToken) {
        SourceDownloader.default.cancelDownload(self.urlString, token: token)
    }
}

extension AnimationImage {
}

// MARK: - Get frame duration for animator
extension AnimationImage {
    internal class func getFrameDuration(from imageSource: CGImageSource, at idx: Int) -> TimeInterval {
        guard let property = CGImageSourceCopyPropertiesAtIndex(imageSource, idx, nil) as? [String: Any] else {
            return 0.0
        }
        let defaultDuration: TimeInterval = 0.0167
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
        //return frameDuration.doubleValue > 0.0167 ? frameDuration.doubleValue : defaultDuration
        return max(frameDuration.doubleValue, defaultDuration)
    }
}

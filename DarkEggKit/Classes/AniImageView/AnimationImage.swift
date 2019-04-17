//
//  AImage.swift
//  VTuberApp_iOS
//
//  Created by darkzero on 2018/11/26.
//  Copyright © 2018年 darkzero. All rights reserved.
//

import ImageIO
import UIKit

protocol AnimationImageDelegate {
    func animationImage(_ img: AnimationImage, loadSuccess: Bool)
}

extension AnimationImageDelegate {
    func animationImage(_ img: AnimationImage, loadSuccess: Bool){}
}

public class AnimationImage: NSObject {
    private let urlString: String
    internal var imageSource: CGImageSource?
    internal var delegate: AnimationImageDelegate?
    internal var loadCompletion: ((UIImage?) -> Void) = {(img) in }
    
    public static func ==(l: AnimationImage, r: AnimationImage) -> Bool {
        return l.urlString == r.urlString
    }
    
    public convenience init?(url: String) {
        // if already in cache
        if let src = SourceCache.default.findSource(from: url) {
            Logger.debug("from cache")
            self.init(source: src, urlStr: url)
        } else {
            Logger.debug("from url")
            self.init(urlStr: url)
        }
    }
    
    private init(source: CGImageSource, urlStr: String) {
        self.imageSource = source
        self.urlString = urlStr
        super.init()
        self.delegate?.animationImage(self, loadSuccess: true)
    }
    
    private init(urlStr: String) {
        self.urlString = urlStr
        super.init()
        //self.delegate?.animationImage(self, loadSuccess: true)
    }
}

extension AnimationImage {
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


// MARK: - Load Task
extension AnimationImage {
    internal func startLoad() {
        guard self.imageSource == nil else {
            return
        }
        Logger.debug("start download")
        SourceDownloader.default.downloadImage(from: self.urlString) { (result) in
            switch result {
            case .success(let src):
                Logger.debug("download success")
                self.imageSource = src
                SourceCache.default.add(url: self.urlString, source: src)
                self.delegate?.animationImage(self, loadSuccess: true)
                break
            case .failure:
                Logger.debug("download failure")
                self.delegate?.animationImage(self, loadSuccess: false)
                break
            }
        }
    }
}

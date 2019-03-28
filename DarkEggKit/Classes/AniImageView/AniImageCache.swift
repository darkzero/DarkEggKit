////
//  AniImageCache.swift
//
//  Created by Yuhua Hu on 2019/03/27.
//

import UIKit

public class AniImageCache {
    static let `default`: AniImageCache = {AniImageCache()}();
    private var cache: NSCache<NSObject, CGImageSource> = NSCache()
    
    internal func loadImage(from url: String) -> CGImageSource? {
        let key = NSString(string: url)
        // check cache
        if let src = cache.object(forKey: key) {
            return src
        }
        // check storage
        
        // load from url
        if let _url = URL(string: url) {
            guard let src = CGImageSourceCreateWithURL(_url as CFURL, nil), CGImageSourceGetCount(src) > 0 else {
                return nil
            }
            // save in cache
            self.cache.setObject(src, forKey: key)
            return src
        }
        return nil
    }
    
    internal func add(source: CGImageSource) {
        let key = source.hashValue
        guard let _ = cache.object(forKey: NSNumber(value: key)) else {
            cache.setObject(source, forKey: NSNumber(value: key))
            return
        }
    }
}

//extension DZImageCache {
//    
//}

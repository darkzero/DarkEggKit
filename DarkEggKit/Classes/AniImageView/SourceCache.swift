////
//  AniImageCache.swift
//
//  Created by darkzero on 2019/03/27.
//

import UIKit

public class SourceCache: NSObject {
    static let `default`: SourceCache = {SourceCache()}();
    private var cache: NSCache<NSObject, CGImageSource> = NSCache()
    
    internal func findSource(from url: String) -> CGImageSource? {
        Logger.debug("start load")
        let key = NSString(string: url)
        // check cache
        if let src = cache.object(forKey: key) {
            Logger.debug("end load from cache")
            return src
        }
        // TODO: check storage
        return nil
    }
    
    internal func add(url: String, source: CGImageSource) {
        let key = NSString(string: url)
        guard let _ = cache.object(forKey: key) else {
            cache.setObject(source, forKey: key)
            return
        }
    }
}

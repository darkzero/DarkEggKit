////
//  AniImageCache.swift
//
//  Created by darkzero on 2019/03/27.
//

import UIKit

internal class SourceCache: NSObject {
    internal static let `default`: SourceCache = {SourceCache()}();
    private var cache: NSCache<NSObject, CGImageSource> = NSCache()
    
    override init() {
        self.cache.countLimit = 10
    }
    
    internal func findSource(from url: String) -> CGImageSource? {
        Logger.debug("find source in cache")
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
    
    internal func remove(url: String) {
        let key = NSString(string: url)
        cache.removeObject(forKey: key)
    }
    
    internal func clear() {
        self.cache.removeAllObjects()
    }
}

// MARK: - File cache
extension SourceCache {
    private func saveToFile(url: String, src: CGImageSource) {
        fatalError("TODO: ")
    }
    
    private func loadFromFile(url: String) -> CGImageSource? {
        fatalError("TODO: ")
        //return nil
    }
}

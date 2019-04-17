//
//  ImageDownloader.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/04/17.
//

import UIKit

class SourceDownloader: NSObject {
    public static let `default` = SourceDownloader(name: "default")
    
    public var tasks: [String: SessionDataTask] = [:]
    private let name: String
    
    public struct DownloadTask {
        public let sessionTask: SessionDataTask
        public let cancelToken: SessionDataTask.CancelToken
    }
    
    private init(name: String) {
        if name.isEmpty {
            fatalError("You should specify a name for the downloader. A downloader with empty name is not permitted.")
        }
        self.name = name
    }
}

extension SourceDownloader {
    public func downloadImage(from url: String, completion: @escaping ((DownloadResult)->Void)) {
        if let task = self.tasks[url] {
            task.addCallback(SessionDataTask.TaskCallback(onCompleted: completion))
            return
        }
        let task = SessionDataTask(url: url)
        self.tasks[url] = task
        task.addCallback(SessionDataTask.TaskCallback(onCompleted: { (result) in
            self.tasks.removeValue(forKey: url)
            completion(result)
        }))
        task.start()
        return
    }
}

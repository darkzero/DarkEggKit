//
//  dd.swift
//  DarkEggKit
//
//  Created by darkzero on 2019/04/17.
//

enum DownloadResult {
    case success(_ source: CGImageSource)
    case failure
}

public class SessionDataTask: NSObject {
    public typealias CancelToken = Int
    private let urlString: String
    
    // for async
    var incrementalImgSrc: CGImageSource = CGImageSourceCreateIncremental(nil)
    var recievedData = Data()
    var expectedLeght: Int64 = 0
    
    internal var sessionDataTask: URLSessionDataTask?
    private var callbacks: [SessionDataTask.CancelToken: TaskCallback] = [:]
    private var started: Bool = false
    
    private let lock = NSLock()
    private var currentToken = 0
    
    public struct TaskCallback {
        let onCompleted: ((DownloadResult)->Void)?
        let onProgress: ((Float)->Void)?
    }
    
    init(url: String) {
        //Logger.debug()
        self.urlString = url
    }
    
    deinit {
        //Logger.debug()
    }
}

extension SessionDataTask {
    /// start
    func start() {
        guard !self.started else {
            return
        }
        self.recievedData = Data()
        self.incrementalImgSrc = CGImageSourceCreateIncremental(nil)
        self.sessionDataTask = self.loadImageAsync(from: self.urlString)
        self.sessionDataTask?.resume()
        self.started = true
    }
    
    /// Add one callback
    func addCallback(_ callback: TaskCallback) -> CancelToken {
        lock.lock()
        defer { lock.unlock() }
        callbacks[currentToken] = callback
        defer { currentToken += 1 }
        return currentToken
    }
    
    /// Cancel one callback
    func cancel(token: CancelToken) {
        lock.lock()
        defer { lock.unlock() }
        self.callbacks.removeValue(forKey: token)
        if self.callbacks.count <= 0 {
            self.cancelAll()
        }
    }
    
    /// Cancel all callbacks
    /// then cancel the URLSessionDataTask
    func cancelAll() {
        self.callbacks.removeAll()
        self.sessionDataTask?.cancel()
        self.sessionDataTask = nil
        self.started = false
    }
    
    /// Check if there is callback
    internal var containsCallbacks: Bool {
        return self.callbacks.count > 0
    }
}

// MARK: - URLSessionDataDelegate
extension SessionDataTask: URLSessionDataDelegate {
    internal func loadImageAsync(from url: String) -> URLSessionDataTask? {
        if let url = URL(string: url) {
            let session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: OperationQueue())
            session.configuration.timeoutIntervalForRequest = 15
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            let sessionTask = session.dataTask(with: urlRequest)
            return sessionTask
        }
        return nil
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        self.expectedLeght = response.expectedContentLength
        //Logger.debug("_expectedLeght: ", expectedLeght);
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        recievedData.append(data)
        let isloadFinish = (self.expectedLeght == self.recievedData.count)
        if isloadFinish {
            CGImageSourceUpdateData(incrementalImgSrc, self.recievedData as CFData, isloadFinish)
            self.onUrlSessionLoadEnd(source: incrementalImgSrc)
            self.recievedData = Data()
            session.invalidateAndCancel()
            dataTask.cancel()
        }
        else {
            let per = Float(self.recievedData.count)/Float(self.expectedLeght)
            self.onUrlSessionLoaded(percent: per)
        }
    }
}

// MARK: -
extension SessionDataTask {
    private func onUrlSessionLoadEnd(source: CGImageSource?) {
        for tcb in self.callbacks {
            if let src = source {
                tcb.value.onCompleted?(.success(src))
            }
            else {
                tcb.value.onCompleted?(.failure)
            }
        }
        self.cancelAll()
    }
    
    private func onUrlSessionLoaded(percent: Float = 0) {
        for tcb in self.callbacks {
            tcb.value.onProgress?(percent)
        }
    }
}

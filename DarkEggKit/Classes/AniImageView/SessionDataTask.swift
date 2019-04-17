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
    private let urlString: String
    
    // for async
    var incrementalImgSrc = CGImageSourceCreateIncremental(nil)
    var recievedData = Data()
    var expectedLeght: Int64 = 0
    
    public var task: URLSessionDataTask?
    public var callbacks: [SessionDataTask.CancelToken: TaskCallback] = [:]
    private var started: Bool = false
    public typealias CancelToken = Int
    
    public struct TaskCallback {
        let onCompleted: ((DownloadResult)->Void)
    }
    
    init(url: String) {
        self.urlString = url
    }
    
    // start
    func start() {
        self.task = self.loadImageAsync(from: self.urlString)
        self.task?.resume()
    }
    
    func cancel(token: CancelToken) {
        self.callbacks.removeValue(forKey: token)
        if self.callbacks.count <= 0 {
            task?.cancel()
        }
    }
    
    private func onUrlSessionLoadEnd(source: CGImageSource?) {
        for tcb in self.callbacks {
            if let src = source {
                tcb.value.onCompleted(.success(src))
            }
            else {
                tcb.value.onCompleted(.failure)
            }
        }
    }
    
    private let lock = NSLock()
    private var currentToken = 0
    func addCallback(_ callback: TaskCallback) {
        lock.lock()
        defer { lock.unlock() }
        callbacks[currentToken] = callback
        defer { currentToken += 1 }
        return
        //return currentToken
    }
}

// MARK: - Loading
extension SessionDataTask: URLSessionDataDelegate {
    internal func loadImageAsync(from url: String) -> URLSessionDataTask? {
        if let url = URL(string: url) {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
            let urlRequest = URLRequest(url: url)
            let sessionTask = session.dataTask(with: urlRequest)
            return sessionTask
        }
        return nil
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        self.expectedLeght = response.expectedContentLength;
        Logger.debug("_expectedLeght: ", expectedLeght);
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //data.regions
        recievedData.append(data)
        let isloadFinish = (self.expectedLeght == self.recievedData.count)
        
        CGImageSourceUpdateData(incrementalImgSrc, self.recievedData as CFData, isloadFinish)
        //let imageRef = CGImageSourceCreateImageAtIndex(incrementalImgSrc, 0, nil);
        //let img = UIImage(cgImage: imageRef!)
        Logger.debug("_recieveData: ", data)
        if isloadFinish {
            self.onUrlSessionLoadEnd(source: incrementalImgSrc)
        }
    }
}

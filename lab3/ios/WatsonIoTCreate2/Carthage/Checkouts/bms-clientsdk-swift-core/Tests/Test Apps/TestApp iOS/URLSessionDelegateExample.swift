/*
*     Copyright 2017 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/



import BMSCore



// MARK: - Swift 3

#if swift(>=3.0)

    

class URLSessionDelegateExample: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    
    var response: URLResponse?
    var dataReceived = Data()
    
    let viewController: ViewController
    
    let logger = Logger.logger(name: "TestAppiOS")
    
    
    
    init(viewController: ViewController) {
        
        self.viewController = viewController
    }
    
    
    
    // MARK: NSURLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        logger.error(message: "Error: \(error.debugDescription)\n")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        logger.info(message: "\n")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        logger.debug(message: "\n")
    }
    
    
    // MARK: NSURLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        logger.debug(message: "\n")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        logger.info(message: "\n")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        
        logger.debug(message: "\n")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        DispatchQueue.main.async {
            let currentProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            self.viewController.progressBar.setProgress(currentProgress, animated: false)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        logger.error(message: "Error: \(error.debugDescription)\n")
        
        self.viewController.displayData(dataReceived, response: self.response, error: nil)
        if error != nil {
            self.viewController.displayData(nil, response: nil, error: error)
        }
    }
    
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        
        logger.debug(message: "\n")
    }
    
    
    // MARK: NSURLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        logger.info(message: "Response: \(response)\n")
        
        self.response = response
        self.viewController.displayData(nil, response: response, error: nil)
        
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
        logger.debug(message: "\n")
    }
    
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
     
        logger.debug(message: "\n")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        // Turned off for tasks that download/upload a lot of data
        //        logger.info("")
        dataReceived.append(data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        
        logger.debug(message: "\n")
    }
}
    
    
    
    
    
/**************************************************************************************************/
    
    
    
    
    
// MARK: - Swift 2
    
#else
    
    

class URLSessionDelegateExample: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate {
    
    
    var response: NSURLResponse?
    var dataReceived = NSMutableData()
    
    let viewController: ViewController
    
    let logger = Logger.logger(name: "TestAppiOS")
    
    
    
    init(viewController: ViewController) {
        
        self.viewController = viewController
    }
    
    
    
    // MARK: NSURLSessionDelegate
    
    internal func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        
        logger.error(message: "Error: \(error.debugDescription)\n")
    }
    
    internal func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        logger.info(message: "\n")
    }
    
    internal func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
        logger.debug(message: "\n")
    }
    
    
    // MARK: NSURLSessionTaskDelegate
    
    internal func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        
        logger.debug(message: "\n")
    }
    
    internal func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        logger.info(message: "\n")
    }
    
    internal func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        
        logger.debug(message: "\n")
    }
    
    internal func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        dispatch_async(dispatch_get_main_queue()) {
            let currentProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            self.viewController.progressBar.setProgress(currentProgress, animated: false)
        }
    }
    
    internal func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        logger.error(message: "Error: \(error.debugDescription)\n")
        
        self.viewController.displayData(dataReceived, response: self.response, error: nil)
        if error != nil {
            self.viewController.displayData(nil, response: nil, error: error)
        }
    }
    
    
    // MARK: NSURLSessionDataDelegate
    
    internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        logger.info(message: "Response: \(response)\n")
        
        self.response = response
        self.viewController.displayData(nil, response: response, error: nil)
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        
        logger.debug(message: "\n")
    }
    
    internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        // Turned off for tasks that download/upload a lot of data
//        logger.info("")
        dataReceived.appendData(data)
    }
    
    internal func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        
        logger.debug(message: "\n")
    }
}


    
#endif

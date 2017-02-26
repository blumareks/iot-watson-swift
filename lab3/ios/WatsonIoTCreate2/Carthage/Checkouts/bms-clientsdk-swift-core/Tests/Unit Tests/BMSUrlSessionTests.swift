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


import XCTest
@testable import BMSCore



// MARK: - Swift 3

#if swift(>=3.0)



class BMSUrlSessionTests: XCTestCase {

    
    var testBundle = Bundle.main
    var testUrl = URL(string: "BMSURLSessionTests")!
    
    
    override func setUp() {
        
        testBundle = Bundle(for: type(of: self))
        testUrl = testBundle.url(forResource: "Andromeda", withExtension: "jpg")!
        
        BMSURLSession.shouldRecordNetworkMetadata = true
    }
    
    
    
    // MARK: - Data Tasks
    
    // This also tests dataTaskWithURL(_ url: URL)
    func testDataTaskWithRequest() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        let dataTaskWithUrl: URLSessionDataTask = bmsSession.dataTask(with: testUrl)
        let dataTaskWithRequest: URLSessionDataTask = bmsSession.dataTask(with: request)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(dataTaskWithUrl.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
        XCTAssertNotNil(dataTaskWithRequest.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testDataTaskWithRequestAndCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        func testCompletionHandler(data: Data?, response: URLResponse?, error: Error?) { }
        
        let dataTaskWithUrl: URLSessionDataTask = bmsSession.dataTask(with: testUrl, completionHandler: testCompletionHandler)
        let dataTaskWithRequest: URLSessionDataTask = bmsSession.dataTask(with: request, completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(dataTaskWithUrl.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
        XCTAssertNotNil(dataTaskWithRequest.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    
    // MARK: - Upload Tasks
    
    func testUploadTaskWithRequestFromData() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        let uploadTaskFromData: URLSessionUploadTask = bmsSession.uploadTask(with: request, from: Data())
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromData.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromDataWithCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        func testCompletionHandler(data: Data?, response: URLResponse?, error: Error?) { }
        
        let uploadTaskFromData: URLSessionUploadTask = bmsSession.uploadTask(with: request, from: Data(), completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromData.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromFile() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        let uploadTaskFromFile: URLSessionUploadTask = bmsSession.uploadTask(with: request, fromFile: testUrl)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromFile.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromFileWithCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = URLRequest(url: testUrl)
        
        func testCompletionHandler(data: Data?, response: URLResponse?, error: Error?) { }
        
        let uploadTaskFromFile: URLSessionUploadTask = bmsSession.uploadTask(with: request, fromFile: testUrl, completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromFile.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
}
    
    
    
    
    
/**************************************************************************************************/
    
    
    
    
    
// MARK: - Swift 2
    
#else

    
    
class BMSUrlSessionTests: XCTestCase {
    
    
    var testBundle = NSBundle.mainBundle()
    var testUrl = NSURL(fileURLWithPath: "BMSURLSessionTests")
    
    
    
    override func setUp() {
        
        testBundle = NSBundle(forClass: self.dynamicType)
        testUrl = testBundle.URLForResource("Andromeda", withExtension: "jpg")!
        
        BMSURLSession.shouldRecordNetworkMetadata = true
    }
    
    
    
    // MARK: - Data Tasks
    
    // This also tests dataTaskWithURL(_ url: URL)
    func testDataTaskWithRequest() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        let dataTaskWithUrl: NSURLSessionDataTask = bmsSession.dataTaskWithURL(testUrl)
        let dataTaskWithRequest: NSURLSessionDataTask = bmsSession.dataTaskWithRequest(request)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(dataTaskWithUrl.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
        XCTAssertNotNil(dataTaskWithRequest.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testDataTaskWithRequestAndCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        func testCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) { }
        
        let dataTaskWithUrl: NSURLSessionDataTask = bmsSession.dataTaskWithURL(testUrl, completionHandler: testCompletionHandler)
        let dataTaskWithRequest: NSURLSessionDataTask = bmsSession.dataTaskWithRequest(request, completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(dataTaskWithUrl.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
        XCTAssertNotNil(dataTaskWithRequest.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    
    // MARK: - Upload Tasks
    
    func testUploadTaskWithRequestFromData() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        let uploadTaskFromData: NSURLSessionUploadTask = bmsSession.uploadTaskWithRequest(request, fromData: NSData())
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromData.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromDataWithCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        func testCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) { }
        
        let uploadTaskFromData: NSURLSessionUploadTask = bmsSession.uploadTaskWithRequest(request, fromData: NSData(), completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromData.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromFile() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        let uploadTaskFromFile: NSURLSessionUploadTask = bmsSession.uploadTaskWithRequest(request, fromFile: testUrl)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromFile.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
    
    func testUploadTaskWithRequestFromFileWithCompletionHandler() {
        
        let bmsSession = BMSURLSession()
        
        let request = NSURLRequest(URL: testUrl)
        
        func testCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) { }
        
        let uploadTaskFromFile: NSURLSessionUploadTask = bmsSession.uploadTaskWithRequest(request, fromFile: testUrl, completionHandler: testCompletionHandler)
        
        // Make sure request has some BMS stuff in it
        XCTAssertNotNil(uploadTaskFromFile.originalRequest?.allHTTPHeaderFields?["x-wl-analytics-tracking-id"])
    }
    
}

    
    
#endif

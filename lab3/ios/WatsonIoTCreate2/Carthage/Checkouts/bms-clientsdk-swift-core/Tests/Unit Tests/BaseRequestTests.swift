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
    
    

class BaseRequestTests: XCTestCase {
    
    
    // MARK: init
    
    func testInitWithAllParameters() {
        
        let request = BaseRequest(url: "http://example.com", method: HttpMethod.GET, headers:[BaseRequest.contentType: "text/plain"], queryParameters: ["someKey": "someValue"], timeout: 10.0, autoRetries: 4)
        
        XCTAssertEqual(request.resourceUrl, "http://example.com")
        XCTAssertEqual(request.httpMethod.rawValue, "GET")
        XCTAssertEqual(request.timeout, 10.0)
        XCTAssertEqual(request.headers, [BaseRequest.contentType: "text/plain"])
        XCTAssertEqual(request.queryParameters!, ["someKey": "someValue"])
        XCTAssertEqual(request.urlSession.numberOfRetries, 4)
        XCTAssertNotNil(request.networkRequest)
    }
    
    func testInitWithRelativeUrl() {
    
        BMSClient.sharedInstance.initialize(bluemixAppRoute: "https://mybluemixapp.net", bluemixAppGUID: "1234", bluemixRegion: BMSClient.Region.usSouth)
        
        let request = BaseRequest(url: "/path/to/resource", headers: nil, queryParameters: nil)
        
        XCTAssertEqual(request.resourceUrl, "https://mybluemixapp.net/path/to/resource")
    }
    
    func testInitWithDefaultParameters() {
        
        let request = BaseRequest(url: "http://example.com", headers: nil, queryParameters: nil)
        
        XCTAssertEqual(request.resourceUrl, "http://example.com")
        XCTAssertEqual(request.httpMethod.rawValue, "GET")
        XCTAssertEqual(request.timeout, BMSClient.sharedInstance.requestTimeout)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertNotNil(request.networkRequest)
    }
    
    
    
    // MARK: send
    
    func testSend() {
        
        let request = BaseRequest(url: "http://example.com", headers: nil, queryParameters: ["someKey": "someValue"])
        
        let requestData = "{\"key1\": \"value1\", \"key2\": \"value2\"}".data(using: .utf8)
        
        request.send(requestBody: requestData!, completionHandler: nil)
        
        XCTAssertNil(request.headers["x-mfp-analytics-metadata"]) // This can only be set by the BMSAnalytics framework
        
        XCTAssertEqual(request.requestBody, requestData)
        XCTAssertEqual(request.resourceUrl, "http://example.com?someKey=someValue")
    }
    
    func testSendWithoutOverwritingContentTypeHeader() {
        
        let request = BaseRequest(url: "http://example.com", headers: [BaseRequest.contentType: "media-type"], queryParameters: ["someKey": "someValue"])
        let dataString = "Some data text"
        
        let bodyData = "Some data text".data(using: .utf8)
        request.send(requestBody: bodyData, completionHandler: nil)
        let requestBodyAsString = String(data: request.requestBody!, encoding: .utf8)
        
        XCTAssertNil(request.headers["x-mfp-analytics-metadata"]) // This can only be set by the BMSAnalytics framework
        
        XCTAssertEqual(requestBodyAsString, dataString)
        XCTAssertEqual(request.headers[BaseRequest.contentType], "media-type")
        XCTAssertEqual(request.resourceUrl, "http://example.com?someKey=someValue")
    }
    
    func testSendWithMalformedUrl() {
        
        let responseReceivedExpectation = self.expectation(description: "Receive network response")
        
        let badUrl = "!@#$%^&*()"
        let request = BaseRequest(url: badUrl, headers: nil, queryParameters: nil)
        
        request.send { (response: Response?, error: Error?) -> Void in
            XCTAssertNil(response)
            XCTAssertEqual((error as? BMSCoreError), BMSCoreError.malformedUrl)
            
            responseReceivedExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { (error: Error?) -> Void in
            if error != nil {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }
    
    
    
    // MARK: appendQueryParameters
    
    func testAppendWithEmptyParameters() {
        
        let parameters: [String: String] = [:]
        
        let url = URL(string: "http://example.com")
        let finalUrl = String( describing: BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssertEqual(finalUrl, "http://example.com")
    }
    
    
    func testAppendWithValidParameters() {
        
        let parameters = ["key1": "value1", "key2": "value2"]
        
        let url = URL(string: "http://example.com")
        let finalUrl = String( describing: BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssertEqual(finalUrl, "http://example.com?key2=value2&key1=value1")
    }
    
    func testAppendWithReservedCharacters() {
        
        let parameters = ["Reserved_characters": "\"#%<>[\\]^`{|}"]
        
        let url = URL(string: "http://example.com")
        let finalUrl = String( describing: BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssert(finalUrl.contains("%22%23%25%3C%3E%5B%5C%5D%5E%60%7B%7C%7D"))
    }
    
    func testAppendDoesNotOverwriteUrlParameters() {
        
        let parameters = ["key1": "value1", "key2": "value2"]
        
        let url = URL(string: "http://example.com?hardCodedKey=hardCodedValue")
        let finalUrl = String( describing: BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssertEqual(finalUrl, "http://example.com?hardCodedKey=hardCodedValue&key2=value2&key1=value1")
    }
    
    func testAppendWithCorrectNumberOfAmpersands() {
        
        let parameters = ["k1": "v1", "k2": "v2", "k3": "v3", "k4": "v4"]
        
        let url = URL(string: "http://example.com")
        let finalUrl = String( describing: BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        let numberOfAmpersands = finalUrl.components(separatedBy: "&")
        
        XCTAssertEqual(numberOfAmpersands.count - 1, 3)
    }

}
    
    
    
    
    
/**************************************************************************************************/
    
    
    
    
    
// MARK: - Swift 2
    
#else
    
    

class BaseRequestTests: XCTestCase {
    
    
    // MARK: init
    
    func testInitWithAllParameters() {
        
        let request = BaseRequest(url: "http://example.com", method: HttpMethod.GET, headers:[BaseRequest.contentType: "text/plain"], queryParameters: ["someKey": "someValue"], timeout: 10.0, autoRetries: 4)
        
        XCTAssertEqual(request.resourceUrl, "http://example.com")
        XCTAssertEqual(request.httpMethod.rawValue, "GET")
        XCTAssertEqual(request.timeout, 10.0)
        XCTAssertEqual(request.headers, [BaseRequest.contentType: "text/plain"])
        XCTAssertEqual(request.queryParameters!, ["someKey": "someValue"])
        XCTAssertEqual(request.urlSession.numberOfRetries, 4)
        XCTAssertNotNil(request.networkRequest)
    }
    
    func testInitWithRelativeUrl() {
        
        BMSClient.sharedInstance.initialize(bluemixAppRoute: "https://mybluemixapp.net", bluemixAppGUID: "1234", bluemixRegion: BMSClient.Region.usSouth)
        
        let request = BaseRequest(url: "/path/to/resource", headers: nil, queryParameters: nil)
        
        XCTAssertEqual(request.resourceUrl, "https://mybluemixapp.net/path/to/resource")
    }
    
    func testInitWithDefaultParameters() {
        
        let request = BaseRequest(url: "http://example.com", headers: nil, queryParameters: nil)
        
        XCTAssertEqual(request.resourceUrl, "http://example.com")
        XCTAssertEqual(request.httpMethod.rawValue, "GET")
        XCTAssertEqual(request.timeout, BMSClient.sharedInstance.requestTimeout)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertTrue(request.headers.isEmpty)
        XCTAssertNotNil(request.networkRequest)
    }
    
    
    
    // MARK: send
    
    func testSend() {
        
        let request = BaseRequest(url: "http://example.com", headers: nil, queryParameters: ["someKey": "someValue"])
        
        let requestData = "{\"key1\": \"value1\", \"key2\": \"value2\"}".dataUsingEncoding(NSUTF8StringEncoding)
        
        request.send(requestBody: requestData!, completionHandler: nil)
        
        XCTAssertNil(request.headers["x-mfp-analytics-metadata"]) // This can only be set by the BMSAnalytics framework
        
        XCTAssertEqual(request.requestBody, requestData)
        XCTAssertEqual(request.resourceUrl, "http://example.com?someKey=someValue")
    }
    
    
    func testSendWithoutOverwritingContentTypeHeader() {
        
        let request = BaseRequest(url: "http://example.com", headers: [BaseRequest.contentType: "media-type"], queryParameters: ["someKey": "someValue"])
        let dataString = "Some data text"
        
        let bodyData = "Some data text".dataUsingEncoding(NSUTF8StringEncoding)
        request.send(requestBody: bodyData, completionHandler: nil)
        let requestBodyAsString = NSString(data: request.requestBody!, encoding: NSUTF8StringEncoding) as? String
    
        XCTAssertNil(request.headers["x-mfp-analytics-metadata"]) // This can only be set by the BMSAnalytics framework
        
        XCTAssertEqual(requestBodyAsString, dataString)
        XCTAssertEqual(request.headers[BaseRequest.contentType], "media-type")
        XCTAssertEqual(request.resourceUrl, "http://example.com?someKey=someValue")
    }
    
    func testSendWithMalformedUrl() {
        
        let responseReceivedExpectation = self.expectationWithDescription("Receive network response")
        
        let badUrl = "!@#$%^&*()"
        let request = BaseRequest(url: badUrl, headers: nil, queryParameters: nil)
        
        request.send { (response: Response?, error: NSError?) -> Void in
            XCTAssertNil(response)
            XCTAssertEqual(error?.domain, BMSCoreError.domain)
            XCTAssertEqual(error?.code, BMSCoreError.malformedUrl.rawValue)
            
            responseReceivedExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0) { (error: NSError?) -> Void in
            if error != nil {
                XCTFail("Expectation failed with error: \(error)")
            }
        }
    }
    
    
    
    // MARK: appendQueryParameters
    
    func testAppendWithEmptyParameters() {
        
        let parameters: [String: String] = [:]
        
        let url = NSURL(string: "http://example.com")
        let finalUrl = String( BaseRequest.append(queryParameters: parameters, toURL: url!)! )
    
        XCTAssertEqual(finalUrl, "http://example.com")
    }
    
    
    func testAppendWithValidParameters() {
        
        let parameters = ["key1": "value1", "key2": "value2"]
        
        let url = NSURL(string: "http://example.com")
        let finalUrl = String( BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssertEqual(finalUrl, "http://example.com?key1=value1&key2=value2")
    }
    
    func testAppendWithReservedCharacters() {
        
        let parameters = ["Reserved_characters": "\"#%<>[\\]^`{|}"]
        
        let url = NSURL(string: "http://example.com")
        let finalUrl = String( BaseRequest.append(queryParameters: parameters, toURL: url!)! )
        
        XCTAssert(finalUrl.containsString("%22%23%25%3C%3E%5B%5C%5D%5E%60%7B%7C%7D"))
    }
    
    func testAppendDoesNotOverwriteUrlParameters() {
        
        let parameters = ["key1": "value1", "key2": "value2"]
        
        let url = NSURL(string: "http://example.com?hardCodedKey=hardCodedValue")
        let finalUrl = String( BaseRequest.append(queryParameters: parameters, toURL: url!)! )
    
        XCTAssertEqual(finalUrl, "http://example.com?hardCodedKey=hardCodedValue&key1=value1&key2=value2")
    }
    
    func testAppendWithCorrectNumberOfAmpersands() {
        
        let parameters = ["k1": "v1", "k2": "v2", "k3": "v3", "k4": "v4"]
        
        let url = NSURL(string: "http://example.com")
        let finalUrl = String( BaseRequest.append(queryParameters: parameters, toURL: url!)! )
    
        let numberOfAmpersands = finalUrl.componentsSeparatedByString("&")
    
        XCTAssertEqual(numberOfAmpersands.count - 1, 3)
    }
    
}



#endif

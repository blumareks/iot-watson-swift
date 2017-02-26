/*
*     Copyright 2016 IBM Corp.
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
    


class ResponseTests: XCTestCase {
    

    func testInit() {
        
        let responseData = "{\"key1\": \"value1\", \"key2\": \"value2\"}".data(using: .utf8)
        let httpURLResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["key": "value"])
        
        let testResponse = Response(responseData: responseData!, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(testResponse.statusCode, 200)
        XCTAssertEqual(testResponse.headers as! [String: String], ["key": "value"])
        XCTAssertEqual(testResponse.responseData, responseData)
        XCTAssertEqual(testResponse.responseText, "{\"key1\": \"value1\", \"key2\": \"value2\"}")
        XCTAssertEqual(testResponse.httpResponse, httpURLResponse)
        XCTAssertTrue(testResponse.isSuccessful)
        XCTAssertTrue(testResponse.isRedirect)
    }
    
    func testInitWithNilParameters() {
        
        let emptyResponse = Response(responseData: nil, httpResponse: nil, isRedirect: false)
        
        XCTAssertNil(emptyResponse.statusCode)
        XCTAssertNil(emptyResponse.headers)
        XCTAssertNil(emptyResponse.responseData)
        XCTAssertNil(emptyResponse.responseText)
        XCTAssertNil(emptyResponse.httpResponse)
        XCTAssertFalse(emptyResponse.isSuccessful)
        XCTAssertFalse(emptyResponse.isRedirect)
    }
    
    
    
    // MARK: buildResponseWithData()
    
    func testInitWithValidString() {
        
        let responseDataWithValidString = "Some random string data".data(using: .utf8)
        let httpURLResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["key": "value"])
        
        let invalidStringResponse = Response(responseData: responseDataWithValidString!, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(invalidStringResponse.responseData, responseDataWithValidString)
        XCTAssertEqual(invalidStringResponse.responseText, "Some random string data")
    }
    
    func testInitWithNonStringData() {
        
        let responseDataWithNonStringData = Data(bytes: [0x00, 0xFF])
        let httpURLResponse = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["key": "value"])
        
        let invalidStringResponse = Response(responseData: responseDataWithNonStringData, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(invalidStringResponse.responseData, responseDataWithNonStringData)
        XCTAssertNil(invalidStringResponse.responseText)
    }
    
}





/**************************************************************************************************/





// MARK: - Swift 2

#else



class ResponseTests: XCTestCase {
    
    
    func testInit() {
    
        let responseData = "{\"key1\": \"value1\", \"key2\": \"value2\"}".dataUsingEncoding(NSUTF8StringEncoding)
        let httpURLResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: ["key": "value"])
    
        let testResponse = Response(responseData: responseData!, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(testResponse.statusCode, 200)
        XCTAssertEqual(testResponse.headers as! [String: String], ["key": "value"])
        XCTAssertEqual(testResponse.responseData, responseData)
        XCTAssertEqual(testResponse.responseText, "{\"key1\": \"value1\", \"key2\": \"value2\"}")
        XCTAssertEqual(testResponse.httpResponse, httpURLResponse)
        XCTAssertTrue(testResponse.isSuccessful)
        XCTAssertTrue(testResponse.isRedirect)
    }
    
    func testInitWithNilParameters() {
        
        let emptyResponse = Response(responseData: nil, httpResponse: nil, isRedirect: false)
        
        XCTAssertNil(emptyResponse.statusCode)
        XCTAssertNil(emptyResponse.headers)
        XCTAssertNil(emptyResponse.responseData)
        XCTAssertNil(emptyResponse.responseText)
        XCTAssertNil(emptyResponse.httpResponse)
        XCTAssertFalse(emptyResponse.isSuccessful)
        XCTAssertFalse(emptyResponse.isRedirect)
    }
    
    
    
    // MARK: buildResponseWithData()
    
    func testInitWithValidString() {
        
        let responseDataWithValidString = "Some random string data".dataUsingEncoding(NSUTF8StringEncoding)
        let httpURLResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: ["key": "value"])
    
        let invalidStringResponse = Response(responseData: responseDataWithValidString!, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(invalidStringResponse.responseData, responseDataWithValidString)
        XCTAssertEqual(invalidStringResponse.responseText, "Some random string data")
    }
    
    func testInitWithNonStringData() {
        
        let responseDataWithNonStringData = NSData(bytes: [0x00, 0xFF] as [UInt8], length: 2)
        let httpURLResponse = NSHTTPURLResponse(URL: NSURL(string: "http://example.com")!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: ["key": "value"])
    
        let invalidStringResponse = Response(responseData: responseDataWithNonStringData, httpResponse: httpURLResponse, isRedirect: true)
        
        XCTAssertEqual(invalidStringResponse.responseData, responseDataWithNonStringData)
        XCTAssertNil(invalidStringResponse.responseText)
    }
    
}



#endif

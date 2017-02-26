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
@testable import BMSAnalyticsAPI



// MARK: - Swift 3

#if swift(>=3.0)
    
    
    
class RequestMetadataTests: XCTestCase {
    
    
    func testCombinedMetadata() {
        
        let url = URL(string:"http://example.com")!
        let startTime = Int64(Date.timeIntervalSinceReferenceDate * 1000)
        let trackingId = "1234"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let bytesSent = Int64(555)
        let bytesReceived = Int64(666)
        
        var requestMetadata = RequestMetadata(url: url, startTime: startTime, trackingId: trackingId)
        requestMetadata.response = response
        requestMetadata.bytesSent = bytesSent
        requestMetadata.bytesReceived = bytesReceived
        
        let expectation = self.expectation(description: "Should receive request metadata.")
        
        // Need to wait so that the endTime and roundtripTime are larger than startTime
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5000000) , execute: {
            
            requestMetadata.endTime = Int64(Date.timeIntervalSinceReferenceDate * 1000)
            
            let combinedMetadata: [String: Any] = requestMetadata.combinedMetadata
            let endTime = combinedMetadata["$inboundTimestamp"] as! Int
            
            XCTAssertEqual(combinedMetadata["$category"] as! String, "network")
            XCTAssertEqual(combinedMetadata["$trackingid"] as! String, trackingId)
            XCTAssertEqual(combinedMetadata["$outboundTimestamp"] as! Int, Int(startTime))
            XCTAssertGreaterThan(endTime, Int(startTime))
            XCTAssertEqual(combinedMetadata["$roundTripTime"] as! Int, endTime - Int(startTime))
            XCTAssertEqual(combinedMetadata["$bytesSent"] as! Int, Int(bytesSent))
            XCTAssertEqual(combinedMetadata["$bytesReceived"] as! Int, Int(bytesReceived))
            XCTAssertEqual(combinedMetadata["$path"] as! String, url.absoluteString)
            XCTAssertEqual((combinedMetadata["$responseCode"] as! Int), response?.statusCode)
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    
    func testCombinedMetadataWithNilValues() {
        
        let startTime = Int64(Date.timeIntervalSinceReferenceDate * 1000)
        let trackingId = "1234"
        
        let requestMetadata = RequestMetadata(url: nil, startTime: startTime, trackingId: trackingId)
        
        let expectation = self.expectation(description: "Should receive request metadata.")
        
        // Need to wait so that the endTime and roundtripTime are larger than startTime
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5000000) , execute: {
            
            let combinedMetadata: [String: Any] = requestMetadata.combinedMetadata
            
            XCTAssertEqual(combinedMetadata["$category"] as! String, "network")
            XCTAssertEqual(combinedMetadata["$trackingid"] as! String, trackingId)
            XCTAssertEqual(combinedMetadata["$outboundTimestamp"] as! Int, Int(startTime))
            XCTAssertEqual(combinedMetadata["$inboundTimestamp"] as! Int, 0)
            XCTAssertEqual(combinedMetadata["$roundTripTime"] as! Int, 0)
            XCTAssertEqual(combinedMetadata["$bytesSent"] as! Int, 0)
            XCTAssertEqual(combinedMetadata["$bytesReceived"] as! Int, 0)
            XCTAssertNil(combinedMetadata["$path"])
            XCTAssertNil(combinedMetadata["$responseCode"])
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
    }
    
}





/**************************************************************************************************/





// MARK: - Swift 2

#else



class RequestMetadataTests: XCTestCase {
    
    
    func testCombinedMetadata() {
        
        let url = NSURL(string:"http://example.com")!
        let startTime = Int64(NSDate.timeIntervalSinceReferenceDate() * 1000)
        let trackingId = "1234"
        let response = NSHTTPURLResponse(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        let bytesSent = Int64(555)
        let bytesReceived = Int64(666)
        
        var requestMetadata = RequestMetadata(url: url, startTime: startTime, trackingId: trackingId)
        requestMetadata.response = response
        requestMetadata.bytesSent = bytesSent
        requestMetadata.bytesReceived = bytesReceived
        
        let expectation = self.expectationWithDescription("Should receive request metadata.")
        
        // Need to wait so that the endTime and roundtripTime are larger than startTime
        let timeDelay = dispatch_time(DISPATCH_TIME_NOW, 5000000) // 5 milliseconds
        dispatch_after(timeDelay, dispatch_get_main_queue()) { () -> Void in
            
            requestMetadata.endTime = Int64(NSDate.timeIntervalSinceReferenceDate() * 1000)
            
            let combinedMetadata: [String: AnyObject] = requestMetadata.combinedMetadata
            let endTime = combinedMetadata["$inboundTimestamp"] as! Int
            
            XCTAssertEqual(combinedMetadata["$category"] as? String, "network")
            XCTAssertEqual(combinedMetadata["$trackingid"] as? String, trackingId)
            XCTAssertEqual(combinedMetadata["$outboundTimestamp"] as? Int, Int(startTime))
            XCTAssertGreaterThan(endTime, Int(startTime))
            XCTAssertEqual(combinedMetadata["$roundTripTime"] as? Int, endTime - Int(startTime))
            XCTAssertEqual(combinedMetadata["$bytesSent"] as? Int, Int(bytesSent))
            XCTAssertEqual(combinedMetadata["$bytesReceived"] as? Int, Int(bytesReceived))
            XCTAssertEqual(combinedMetadata["$path"] as? String, url.absoluteString)
            XCTAssertEqual((combinedMetadata["$responseCode"] as! Int), response?.statusCode)
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    
    func testCombinedMetadataWithNilValues() {
        
        let startTime = Int64(NSDate.timeIntervalSinceReferenceDate() * 1000)
        let trackingId = "1234"
        
        let requestMetadata = RequestMetadata(url: nil, startTime: startTime, trackingId: trackingId)
        
        let expectation = self.expectationWithDescription("Should receive request metadata.")
        
        // Need to wait so that the endTime and roundtripTime are larger than startTime
        let timeDelay = dispatch_time(DISPATCH_TIME_NOW, 5000000) // 5 milliseconds
        dispatch_after(timeDelay, dispatch_get_main_queue()) { () -> Void in
            
            let combinedMetadata: [String: AnyObject] = requestMetadata.combinedMetadata
            
            XCTAssertEqual(combinedMetadata["$category"] as? String, "network")
            XCTAssertEqual(combinedMetadata["$trackingid"] as? String, trackingId)
            XCTAssertEqual(combinedMetadata["$outboundTimestamp"] as? Int, Int(startTime))
            XCTAssertEqual(combinedMetadata["$inboundTimestamp"] as? Int, 0)
            XCTAssertEqual(combinedMetadata["$roundTripTime"] as? Int, 0)
            XCTAssertEqual(combinedMetadata["$bytesSent"] as? Int, 0)
            XCTAssertEqual(combinedMetadata["$bytesReceived"] as? Int, 0)
            XCTAssertNil(combinedMetadata["$path"])
            XCTAssertNil(combinedMetadata["$responseCode"])
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0.1, handler: nil)
    }
}
    
    
    
#endif

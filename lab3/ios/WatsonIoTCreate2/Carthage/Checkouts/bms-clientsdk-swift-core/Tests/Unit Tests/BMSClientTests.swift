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



class BMSClientTests: XCTestCase {
    
    
    func testInitializerWithAllParameters() {
        
        let clientInstance = BMSClient.sharedInstance
        
        clientInstance.initialize(bluemixAppRoute: "http://example.com", bluemixAppGUID: "1234", bluemixRegion:BMSClient.Region.usSouth)
        
        XCTAssertEqual(clientInstance.bluemixAppRoute, "http://example.com")
        XCTAssertEqual(clientInstance.bluemixAppGUID, "1234")
        XCTAssertEqual(clientInstance.bluemixRegion, BMSClient.Region.usSouth)
    }
    
    
    func testInitializerWithOnlyBluemixRegion() {
        
        let clientInstance = BMSClient.sharedInstance
        
        clientInstance.initialize(bluemixRegion: BMSClient.Region.usSouth)
        
        XCTAssertNil(clientInstance.bluemixAppRoute)
        XCTAssertNil(clientInstance.bluemixAppGUID)
        XCTAssertEqual(clientInstance.bluemixRegion, BMSClient.Region.usSouth)
    }
}

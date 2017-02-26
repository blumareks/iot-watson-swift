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
    
    
    
// IMPORTANT: Unit tests are not adequate to ensure that the NetworkMonitor class is behaving correctly. To fully exercise NetworkMonitor, run the "TestApp iOS" target on a real iOS device.
class NetworkDetectionTests: XCTestCase {
    
    
    func testCellularNetworkType() {
        
        let networkDetector = NetworkMonitor()
        XCTAssertNil(networkDetector?.cellularNetworkType)
    }
    
    
    func testCurrentNetworkConnection() {
        
        // Since unit tests run on a Mac, the internet connection must be either WiFi or no connection.
        let networkDetector = NetworkMonitor()
        XCTAssert(networkDetector?.currentNetworkConnection != NetworkConnection.WWAN)
    }

    
    func testNetworkConnection() {
        
        XCTAssertEqual(NetworkConnection.noConnection.description, "No Connection")
        XCTAssertEqual(NetworkConnection.WWAN.description, "WWAN")
        XCTAssertEqual(NetworkConnection.WiFi.description, "WiFi")
    }
    
    
    func testStartMonitoringNetworkChanges() {
        
        let networkDetector = NetworkMonitor()
        let _ = networkDetector!.startMonitoringNetworkChanges()
        
        XCTAssertTrue(networkDetector!.isMonitoringNetworkChanges)
        
        networkDetector!.stopMonitoringNetworkChanges()
        
        XCTAssertFalse(networkDetector!.isMonitoringNetworkChanges)
    }
    
}





/**************************************************************************************************/





// MARK: - Swift 2

#else




// IMPORTANT: Unit tests are not adequate to ensure that the NetworkMonitor class is behaving correctly. To fully exercise NetworkMonitor, run the "TestApp iOS" target on a real iOS device.
class NetworkDetectionTests: XCTestCase {
    
    
    func testCellularNetworkType() {
        
        let networkDetector = NetworkMonitor()
        XCTAssertNil(networkDetector?.cellularNetworkType)
    }
    
    
    func testCurrentNetworkConnection() {
        
        // Since unit tests run on a Mac, the internet connection must be either WiFi or no connection.
        let networkDetector = NetworkMonitor()
        XCTAssert(networkDetector?.currentNetworkConnection != NetworkConnection.WWAN)
    }
    
    
    func testNetworkConnection() {
        
        XCTAssertEqual(NetworkConnection.noConnection.description, "No Connection")
        XCTAssertEqual(NetworkConnection.WWAN.description, "WWAN")
        XCTAssertEqual(NetworkConnection.WiFi.description, "WiFi")
    }
    
    
    func testStartMonitoringNetworkChanges() {
        
        let networkDetector = NetworkMonitor()
        let _ = networkDetector!.startMonitoringNetworkChanges()
        
        XCTAssertTrue(networkDetector!.isMonitoringNetworkChanges)
        
        networkDetector!.stopMonitoringNetworkChanges()
        
        XCTAssertFalse(networkDetector!.isMonitoringNetworkChanges)
    }
    
}



#endif

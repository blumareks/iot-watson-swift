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



class LoggerTests: XCTestCase {
    
    
    func testLogger() {
        
        let name = "sample"
        let logger = Logger.logger(name: name)
        
        XCTAssertTrue(logger.name == Logger.loggerInstances[name]?.name)
    }
    
    
    // Cannot make any assertions since all these log methods do is print to the console
    // More thorough unit testing for the Logger class is done in the BMSAnalytics SDK
    func testLogMethods() {
        
        let name = "sample"
        let loggerInstance = Logger.logger(name: name)
        Logger.logLevelFilter = LogLevel.debug
        
        loggerInstance.debug(message: "Hello world")
        loggerInstance.info(message: "1242342342343243242342")
        loggerInstance.warn(message: "Str: heyoooooo")
        loggerInstance.error(message: "1 2 3 4")
        loggerInstance.fatal(message: "StephenColbert")
    }
    
}

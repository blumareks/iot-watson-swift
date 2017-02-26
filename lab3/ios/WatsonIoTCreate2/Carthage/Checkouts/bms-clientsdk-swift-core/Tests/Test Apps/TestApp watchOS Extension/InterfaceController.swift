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


import WatchKit
import BMSCore


class InterfaceController: WKInterfaceController {

    
    @IBOutlet var responseLabel: WKInterfaceLabel!
    
    
    @IBAction func getRequestButtonPressed() {
        
        #if swift(>=3.0)
            
            let configuration = URLSessionConfiguration.default
            
            // To test auto-retries, set the timeout very close to the time needed to complete the request. This way, some requests will fail due to timeout, but after enough retries, it should succeed.
            configuration.timeoutIntervalForRequest = 10.0
            
            let bmsUrlSession = BMSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil, autoRetries: 5)
            
            let request = URLRequest(url: URL(string: "http://httpbin.org/get")!)
            let dataTask = bmsUrlSession.dataTask(with: request) { (_, response: URLResponse?, error: Error?) in
                
                var responseLabelText = ""
                
                if let responseError = error {
                    responseLabelText = "ERROR"
                    print("ERROR: \(responseError.localizedDescription)")
                }
                else if let response = response as? HTTPURLResponse {
                    let status = response.statusCode
                    responseLabelText = "Status: \(status)"
                }
                
                DispatchQueue.main.async {
                    self.responseLabel.setText(responseLabelText)
                }
            }
            
        #else
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            // To test auto-retries, set the timeout very close to the time needed to complete the request. This way, some requests will fail due to timeout, but after enough retries, it should succeed.
            configuration.timeoutIntervalForRequest = 10.0

            let bmsUrlSession = BMSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil, autoRetries: 5)
            
            let request = NSURLRequest(URL: NSURL(string: "http://httpbin.org/get")!)
            let dataTask = bmsUrlSession.dataTaskWithRequest(request) { (_, response: NSURLResponse?, error: NSError?) in
                
                var responseLabelText = ""
                
                if let responseError = error {
                    responseLabelText = "ERROR"
                    print("ERROR: \(responseError.localizedDescription)")
                }
                else if let response = response as? NSHTTPURLResponse {
                    let status = response.statusCode ?? 0
                    responseLabelText = "Status: \(status)"
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.responseLabel.setText(responseLabelText)
                })
            }
            
        #endif
        
        dataTask.resume()
    }
}

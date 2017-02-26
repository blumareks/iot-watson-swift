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



import UIKit
import BMSCore



// MARK: - Swift 3

#if swift(>=3.0)
    


class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var resourceUrl: UITextField!
    @IBOutlet var httpMethodPicker: UIPickerView!
    @IBOutlet var callbackPicker: UIPickerView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var responseLabel: UITextView!
    
    let callbackViewController = CallbackPickerViewController()
    let httpMethodViewController = HttpMethodPickerViewController()
    
    let logger = Logger.logger(name: "TestAppiOS")

    let imageFile = Bundle.main.url(forResource: "Andromeda", withExtension: "jpg")!
    
    let networkMonitor = NetworkMonitor()!
    
    var bmsUrlSession: BMSURLSession {
        
        let configuration = URLSessionConfiguration.default
        
        // To test auto-retries, set the timeout very close to the time needed to complete the request. This way, some requests will fail due to timeout, but after enough retries, it should succeed.
        configuration.timeoutIntervalForRequest = 10.0
        
        switch callbackViewController.callbackType {
            
        case .delegate:
            return BMSURLSession(configuration: configuration, delegate: URLSessionDelegateExample(viewController: self), delegateQueue: nil, autoRetries: 5)
            
        case .completionHandler:
            return BMSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil, autoRetries: 10)
        }
    }
    
    var request: URLRequest? {
        
        guard let requestUrl = URL(string: resourceUrl.text!) else {
            logger.error(message: "Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethodViewController.httpMethod.rawValue
        return request
    }

    
    @IBAction func sendDataTaskRequest(sender button: UIButton) {
        
        guard request != nil else {
            return
        }
        
        switch callbackViewController.callbackType {
        case .delegate:
            bmsUrlSession.dataTask(with: request!).resume()
        case .completionHandler:
            bmsUrlSession.dataTask(with: request!, completionHandler: displayData).resume()
        }
    }
    
    
    @IBAction func sendUploadTaskRequest(sender button: UIButton) {
        
        guard request != nil else {
            return
        }
        
        switch callbackViewController.callbackType {
        case .delegate:
            bmsUrlSession.uploadTask(with: request!, fromFile: imageFile).resume()
        case .completionHandler:
            bmsUrlSession.uploadTask(with: request!, fromFile: imageFile, completionHandler: displayData).resume()
        }
    }
    
    
    func displayData(_ data: Data?, response: URLResponse?, error: Error?) {
        
        var answer = ""
        if let response = response as? HTTPURLResponse {
            answer += "Status code: \(response.statusCode)\n\n"
        }
        if data != nil {
            answer += "Response Data: \(data!.count) bytes\n\n"
        }
        if error != nil {
            answer += "Error:  \(error!)"
        }
        DispatchQueue.main.async {
            self.responseLabel.text = answer
        }
    }
    
    
    // Prints the current network connection types and monitors any changes (i.e. switching between WiFi, WWAN, and airplane mode)
    // IMPORTANT: To test this fully, use a real device to switch between WiFi, 4G LTE, 3G, and airplane mode.
    func getNetworkInformation() {
     
        let isMonitoringNetworkChanges = networkMonitor.startMonitoringNetworkChanges()
        
        print("Monitoring network changes: \(isMonitoringNetworkChanges)")
        print("Network connection: \(networkMonitor.currentNetworkConnection.description)")
        if let cellularNetwork = networkMonitor.cellularNetworkType {
            print("Cellular network type: \(cellularNetwork)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkNetworkConnection), name: NetworkMonitor.networkChangedNotificationName, object: nil)
    }
    
    
    func checkNetworkConnection() {
        
        print("Changed network connection to: \(networkMonitor.currentNetworkConnection)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callbackPicker.dataSource = callbackViewController
        self.callbackPicker.delegate = callbackViewController
        
        self.httpMethodPicker.dataSource = httpMethodViewController
        self.httpMethodPicker.delegate = httpMethodViewController
        // Default to HTTP POST, since that tends to have many useful test cases
        self.httpMethodPicker.selectRow(1, inComponent: 0, animated: false)
    
        self.progressBar.transform = CGAffineTransform(scaleX: 1, y: 2)
        responseLabel.layer.borderWidth = 1
        
        BMSURLSession.shouldRecordNetworkMetadata = true
        
        getNetworkInformation()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}





/**************************************************************************************************/





// MARK: - Swift 2

#else



class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var resourceUrl: UITextField!
    @IBOutlet var httpMethodPicker: UIPickerView!
    @IBOutlet var callbackPicker: UIPickerView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var responseLabel: UITextView!
    
    let callbackViewController = CallbackPickerViewController()
    let httpMethodViewController = HttpMethodPickerViewController()
    
    let logger = Logger.logger(name: "TestAppiOS")
    
    let imageFile = NSBundle.mainBundle().URLForResource("Andromeda", withExtension: "jpg")!
    
    let networkMonitor = NetworkMonitor()!
    
    
    var bmsUrlSession: BMSURLSession {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // To test auto-retries, set the timeout very close to the time needed to complete the request. This way, some requests will fail due to timeout, but after enough retries, it should succeed.
        configuration.timeoutIntervalForRequest = 10.0

        
        switch callbackViewController.callbackType {
            
        case .delegate:
            return BMSURLSession(configuration: configuration, delegate: URLSessionDelegateExample(viewController: self), delegateQueue: nil, autoRetries: 5)
            
        case .completionHandler:
            return BMSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil, autoRetries: 5)
        }
    }
    
    var request: NSURLRequest? {
    
        guard let requestUrl = NSURL(string: resourceUrl.text!) else {
            logger.error(message: "Invalid URL")
            return nil
        }
    
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = httpMethodViewController.httpMethod.rawValue
        return request
    }
    
    
    @IBAction func sendDataTaskRequest(sender button: UIButton) {
        
        guard request != nil else {
            return
        }
        
        switch callbackViewController.callbackType {
        case .delegate:
            bmsUrlSession.dataTaskWithRequest(request!).resume()
        case .completionHandler:
            bmsUrlSession.dataTaskWithRequest(request!, completionHandler: displayData).resume()
        }
    }
    
    
    @IBAction func sendUploadTaskRequest(sender button: UIButton) {
        
        guard request != nil else {
            return
        }
        
        switch callbackViewController.callbackType {
        case .delegate:
            bmsUrlSession.uploadTaskWithRequest(request!, fromFile: imageFile).resume()
        case .completionHandler:
            bmsUrlSession.uploadTaskWithRequest(request!, fromFile: imageFile, completionHandler: displayData).resume()
        }
    }

    
    func displayData(data: NSData?, response: NSURLResponse?, error: NSError?) {
    
        var answer = ""
        if let response = response as? NSHTTPURLResponse {
            answer += "Status code: \(response.statusCode)\n\n"
        }
        if data != nil {
            answer += "Response Data: \(data!.length) bytes\n\n"
        }
        if error != nil {
            answer += "Error:  \(error!)"
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.responseLabel.text = answer
        })
    }
    
    
    // Prints the current network connection types and monitors any changes (i.e. switching between WiFi, WWAN, and airplane mode)
    // IMPORTANT: To test this fully, use a real device to switch between WiFi, 4G LTE, 3G, and airplane mode.
    func getNetworkInformation() {
        
        let isMonitoringNetworkChanges = networkMonitor.startMonitoringNetworkChanges()
        
        print("Monitoring network changes: \(isMonitoringNetworkChanges)")
        print("Network connection: \(networkMonitor.currentNetworkConnection.description)")
        if let cellularNetwork = networkMonitor.cellularNetworkType {
            print("Cellular network type: \(cellularNetwork)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkNetworkConnection), name: NetworkMonitor.networkChangedNotificationName, object: nil)
    }
        
        
    func checkNetworkConnection() {
        
        print("Changed network connection to: \(networkMonitor.currentNetworkConnection)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callbackPicker.dataSource = callbackViewController
        self.callbackPicker.delegate = callbackViewController
        
        self.httpMethodPicker.dataSource = httpMethodViewController
        self.httpMethodPicker.delegate = httpMethodViewController
        // Default to HTTP POST, since that tends to have many useful test cases
        self.httpMethodPicker.selectRow(1, inComponent: 0, animated: false)

        self.progressBar.transform = CGAffineTransformMakeScale(1, 2)
        responseLabel.layer.borderWidth = 1
        
        BMSURLSession.shouldRecordNetworkMetadata = true
        
        getNetworkInformation()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


    
#endif

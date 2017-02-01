//
//  ViewController.swift
//  CheckIoTTemp
//
//  Created by Marek Sadowski on 2/1/17.
//  Copyright © 2017 Marek Sadowski. All rights reserved.
//

import UIKit
//import SwiftCloudant from CocoaPods
import SwiftCloudant

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    private var jsonTemp = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        NSLog("refresh IoT Temp button pressed")
        
        //get the temp
        //connect to Cloudant
        let cloudantUrl = NSURL(string: "cloudant db connection url")
        let cloudantClient = CouchDBClient(url: cloudantUrl! as URL, username: "cloudant db connection user", password: "cloudant db connection password")
        let database = "temperatures"
        
        //find the temp record
        let find = FindDocumentsOperation(selector: [:], databaseName: database, fields: ["payload", "timestamp"], limit: 1, skip: 0, sort:  [Sort(field: "timestamp", sort: Sort.Direction.desc)], bookmark: nil, useIndex: nil, r: 1)
        { (response, httpInfo, error) in
            if let error = error {
                print("Encountered an error while reading a document. Error:\(error)")
            } else {
                print("Read document: \(response)")
                
        //get the temp value from JSON
                do {
                    let data = try JSONSerialization.data(withJSONObject: response!, options: [])
                    
                    let parsedJson = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    if let nestedArray = parsedJson["docs"] as? NSArray {

                        print("nested \(nestedArray)")
                        //getting nested temp from payload
                        let newDoc = nestedArray[0] as? [String:Any]
                        
                        print("nested \(newDoc)")
                        // access nested dictionary values by key
                        
                        let currentTemperature = newDoc?["payload"] as! Double
                        
                        print("found temp: \(currentTemperature)")
                        self.jsonTemp = currentTemperature
                        
                    }
                    
                } catch  let error as NSError {
                    print(error)
                }
            }
        }
        cloudantClient.add(operation:find)
        //update the label
        //we need to wait for the results
        tempLabel.text = "T= ?"
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            NSLog("Read doc: 1 sec")
            self.tempLabel.text = "T = \(self.jsonTemp)"
        })
        
    }

}


//
//  ViewController.swift
//  WatsonIoTCreate2
//
//  Created by Marek Sadowski on 11/23/16.
//  Copyright © 2016 Marek Sadowski. All rights reserved.
//

import UIKit
import MQTTClient
//STT
import SpeechToTextV1
//TTS
import TextToSpeechV1
//audio!
import AVFoundation

class ViewController: UIViewController {

    let ORG_ID = "<step 1. your_org_id>"
    let ioTHostBase = "messaging.internetofthings.ibmcloud.com"
    let C_ID = "a: <step 1. your_org_id>:RaspberryPiCreate2App"
    let DEV_TYPE = "RPi3"
    let DEV_ID = "RaspberryPi3iRobotCreate2"
    let BEEP_MSG = "1" //play beep
    let DOCK_MSG = "2" //dock
    let IOT_API_KEY = "<step 3. your_boilerplates_iot_apikey>"
    let IOT_AUTH_TOKEN = "<step 2. your_boilerplates_iot_token>"
    
    //STT + Weather + TTS
    @IBOutlet weak var speechToTextLabel: UILabel!
    
    @IBAction func micButtonTouchedDown(_ sender: Any) {
        NSLog("mic button pressed down - starting to listen")
        
        //STT - listen for the *forecast* command
        let usernameSTT = "STT user name from bluemix"
        let passwordSTT = "STT password from bluemix"
        let speechToText = SpeechToText(username: usernameSTT, password: passwordSTT)
        
        var settings = RecognitionSettings(contentType: .opus)
        settings.continuous = false
        settings.interimResults = false
        let failureSTT = {(error: Error) in print(error)}
        speechToText.recognizeMicrophone(settings: settings, failure: failureSTT) { results in
            print(results.bestTranscript)
            self.speechToTextLabel.text! = results.bestTranscript
            NSLog("stopping Mic")
            speechToText.stopRecognizeMicrophone()
            
            if (self.speechToTextLabel.text!.contains("forecast")){
                NSLog("found forecast")
                
                //fetch weather data from Weather Company Data
                let weather = WeatherData()
                weather.getCurrentWeather()
                //print the weather forecast
                print(weather.getGolf())
                sleep(1)// some time to get the result from Weather Company Data
                print(weather.getGolf())
                let textToSay = weather.getGolf()
                
                
                //TTS - say the data
                let username = "TTS user name from bluemix"
                let password = "TTS password from bluemix"
                let textToSpeech = TextToSpeech(username: username, password: password)
                let failureTTS = { (error: Error) in print(error) }
                textToSpeech.synthesize(textToSay, voice: SynthesisVoice.us_Michael.rawValue, failure: failureTTS) { data in
                    var audioPlayer: AVAudioPlayer // see note below
                    audioPlayer = try! AVAudioPlayer(data: data)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    sleep(4)
                    NSLog("end of tts")
                }
                
            }
            NSLog("end STT")
            
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonBeepPressed(_ sender: Any) {
        NSLog("button Beep pressed")
        //send a message to the Watson IoT Platform
        let iotfSession = MQTTSessionManager()
        
        if (iotfSession.state != MQTTSessionManagerState.connected) {
            let host = ORG_ID + "." + ioTHostBase
            let clientId = "a:" + ORG_ID + ":" + IOT_API_KEY
            let CMD_TOPIC = "iot-2/type/" + DEV_TYPE + "/id/" + DEV_ID + "/cmd/cmdapp/fmt/json"
            NSLog("current mqtt topic: " + CMD_TOPIC)
            iotfSession.connect(
                to: host,
                port: 1883,
                tls: false,
                keepalive: 30,
                clean: true,
                auth: true,
                user: IOT_API_KEY,
                pass: IOT_AUTH_TOKEN,
                will: false,
                willTopic: nil,
                willMsg: nil,
                willQos: MQTTQosLevel.atMostOnce,
                willRetainFlag: false,
                withClientId: clientId)
            
            // Wait for the session to connect
            while iotfSession.state != MQTTSessionManagerState.connected {
                NSLog("waiting for connect " + (iotfSession.state).hashValue.description)
                RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1) as Date)
            }
            
            NSLog("connected")
            iotfSession.send(BEEP_MSG.data(using: String.Encoding.utf8, allowLossyConversion: false),
                             topic: CMD_TOPIC,
                             qos: MQTTQosLevel.exactlyOnce,
                             retain: false)
            NSLog("MQTT sent cmd BEEP")
            
        }
    }
    
    @IBAction func buttonDockPressed(_ sender: Any) {
        NSLog("button Dock pressed")
        //send a message to the Watson IoT Platform
        let iotfSession = MQTTSessionManager()
        
        if (iotfSession.state != MQTTSessionManagerState.connected) {
            let host = ORG_ID + "." + ioTHostBase
            let clientId = "a:" + ORG_ID + ":" + IOT_API_KEY
            let CMD_TOPIC = "iot-2/type/" + DEV_TYPE + "/id/" + DEV_ID + "/cmd/cmdapp/fmt/json"
            NSLog("current mqtt topic: " + CMD_TOPIC)
            iotfSession.connect(
                to: host,
                port: 1883,
                tls: false,
                keepalive: 30,
                clean: true,
                auth: true,
                user: IOT_API_KEY,
                pass: IOT_AUTH_TOKEN,
                will: false,
                willTopic: nil,
                willMsg: nil,
                willQos: MQTTQosLevel.atMostOnce,
                willRetainFlag: false,
                withClientId: clientId)
            
            // Wait for the session to connect
            while iotfSession.state != MQTTSessionManagerState.connected {
                NSLog("waiting for connect " + (iotfSession.state).hashValue.description)
                RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 1) as Date)
            }
            
            NSLog("connected")
            iotfSession.send(DOCK_MSG.data(using: String.Encoding.utf8, allowLossyConversion: false),
                                 topic: CMD_TOPIC,
                                 qos: MQTTQosLevel.exactlyOnce,
                                 retain: false)
            NSLog("MQTT sent cmd DOCK")
            
        }
    }

}


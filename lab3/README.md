#Overview

The previous two labs showed us how easily you can connect an IoT to IBM Bluemix and leverage the Watson analytics and external APIs (Twitter and Twilio). This lab demonstrates a further integration of the IoT with smart devices. This lab will show you how you can connect an iOS app with an IoT with the usage of IBM Watson IoT Platform. Optionally we will start to communicate with a robot connected to Raspberry Pi. We will add Voice User Interface to invoke commands on Raspberry Pi. And optionally Voice UI will be all for hands-free usage of the popular STEM robot – iRobot Create2.

## Prerequisites 
You need the following software/hardware:

-	finished LAB1 i LAB2
-	(optional) iRobot Create2

@blumareks, http://blumareks.blogpost.com

The following graph shows the architecture of this lab. On the left side on the bottom there is a smart device that connects to Watson IoT Platform service hosted on the Bluemix. Then the commands issued from the smart device invoke actions on the Raspberry Pi. Raspberry Pi is optionally connected thru a serial port with iRobot Create2.

![architecture](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/architecture.png)

In order to run the example you would need to run the ```pod install``` from the lab3/ios/WatsonIoTCreate2 directory. Please use ```WatsonIoTCreate2.xcworkspace``` to open the project. You need to build the project to be able to leverage the MQTT client (press *play* arrow with the right simulated or actual device).
See the the attached code for setting up the connectivity thru MQTT/WatsonIoTPlatform/Bluemix to Raspberry Pi running Node.Red flow:

```swift
    /*
     "iotCredentialsIdentifier": "???????????",
     "mqtt_host": 
	"<step 1. your_org_id>.messaging.internetofthings.ibmcloud.com",
     "mqtt_u_port": 1883,
     "mqtt_s_port": 8883,
 "http_host": "<step 1. your_org_id>.internetofthings.ibmcloud.com",
 "org": "<step 1. your_org_id>",
 "apiKey": "<step 3. your_boilerplates_iot_apikey>",
 "apiToken": "<step 2. your_boilerplates_iot_token>"
     */

    let ORG_ID = "<step 1. your_org_id>"
    let ioTHostBase = "messaging.internetofthings.ibmcloud.com"
    let C_ID = "a: <step 1. your_org_id>:RaspberryPiCreate2App"
    let DEV_TYPE = "RPi3"
    let DEV_ID = "RaspberryPi3iRobotCreate2"
    let BEEP_MSG = "1" //play beep
    let DOCK_MSG = "2" //dock
    let IOT_API_KEY = "<step 3. your_boilerplates_iot_apikey>"
    let IOT_AUTH_TOKEN = "<step 2. your_boilerplates_iot_token>”
```    
With these parameters when a button is pressed you should create a connection to MQTT queues:

```swift
    let host = ORG_ID + "." + ioTHostBase
    let clientId = "a:" + ORG_ID + ":" + IOT_API_KEY
    let CMD_TOPIC = "iot-2/type/" + DEV_TYPE + "/id/" + DEV_ID + "/cmd/cmdapp/fmt/json"
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
```
		
Finally, you are able to send a command over the created MQTT connection:

```swift
iotfSession.send(BEEP_MSG.data(using: String.Encoding.utf8, allowLossyConversion: false),
                             topic: CMD_TOPIC,
                             qos: MQTTQosLevel.exactlyOnce,
                             retain: false)

```

And the final Node.Red flow working with the Rapberry Pi that receives the command, and selects if it is a BEEP or DOCK:

![the flow](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/lab3RpiFlow.png)



If you have the robot (iRobot Create2) - you might want to connect it now:

![connecting RPi to iRobot Create2's serial port](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/connectRPi2_to_create2.png)

## Adding Voice UI to the solution
In this step we want to ask a question to our robot assistant. That is really simple. We need to add the Voice interface to already built application. My previous MooC was on augmenting an iOS app with Watson services. So it is going to be really fast. We would like to ask a robot assistant about the weather - it would tell is if it is o.k. weather to play golf today.

We would need to create and add 3 additional services:

- Watson SpeechToText - this service is to listen to the command
- Watson TextToSpeech - this service is to vocalize the answer
- Weather Company Data - this service is to fetch the weather forecast

### The steps
We would need to do the following steps:

1. create a cartfile to include Watson-Developer-Cloud sdk for iOS, Bluemix Services sdk for ios, and SwiftyJson sdks. 

First issue the command in the root directory of the app: ```cat > cartfile```,
and copy and paste
```
github "ibm-bluemix-mobile-services/bms-clientsdk-swift-core"
github "SwiftyJSON/SwiftyJSON"
github "watson-developer-cloud/swift-sdk"
``` 

Then We will run the command ```carthage update --platform iOS``` to fetch the libraries from git.
We need to reference the following libraries from the Carthage/iOS directory:
 - BMSAnalytics.framework
 - BMSCore.framework
 - RestKit.framework
 - SpeechToTextV1.framework
 - TextToSpeechV1.framework
 - SwiftyJSON.framework

Than we need to create 2 new .swift files:
- String.swift - to add the encoding for the network
- WeatherData.swift - to manage the connectivity to Weather Company Data

The files need to have the following code:

```swift
import UIKit

// Extending String to support Base64 encoding for network requests
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
```

and
```swift

import Foundation
import BMSCore //querrying Bluemix for Weather Company Data
import SwiftyJSON //working with JSON with Weather forecast

class WeatherData {
    let location = "94596%3A4%3AUS" //find the weather forecast for a zip
    let username: String
    let password: String
    let host: String
    
    var temp0 = 0
    var golf0 = ""
    
    init() {
        username = "Weather Company Data user name from bluemix"
        password = "Weather Company Data password from bluemix"
        host = "twcservice.mybluemix.net"
    }
    
    func getGolf() -> String{
        return "there is a forecast for the temperature \(self.temp0) and the \(self.golf0) golf conditions"
    }
    
    func getCurrentWeather() {
        
        let url = "https://" + host + "/api/weather/v1/location/\(location)/forecast/hourly/48hour.json"
        let basicAuth = "Basic " + "\(username):\(password)".toBase64()
        let headers = ["Authorization" : basicAuth]
        
        
        let request = Request(url: url,
                              method: .GET,
                              headers: headers)
        NSLog("sending request")
        request.send { (response, error) in
            if let error = error {
                NSLog("error sending request")
                print(error)
                return
            }
            guard let response = response else {
                return
            }
            if response.isSuccessful {
                //print(response.responseText!) //what we got from Weather Company Data
                let data = response.responseText!.data(using: String.Encoding.utf8)
                let json = JSON(data: data!)
                //print(json["forecasts"]) //JSON
                let forecasts = json["forecasts"].arrayValue
                self.temp0 = forecasts[0]["temp"].intValue
                self.golf0 = forecasts[0]["golf_category"].stringValue
                NSLog("end of weather company data call : golf0 - temp0")
            } else {
                if response.statusCode! == 401 {
                    print("Failed to connect to the Weather Company Data service due to invalid credentials. Please verify your credentials in the WeatherCredentials.plist file and rebuild the application. See the README for further assistance.")
                } else {
                    print("Failed Request to Weather Service :: Status: \(response.statusCode), Message: \(response.responseText!)")
                }
            }
        }
        
    }
    
}
```
The final 2 steps are to add two new elements to the UI - Main.Storyboard
- a button - position it at the bottom center - with the text MIC
- a label - position it above the button - you can remove all the text

Reference two elements in the code in the ViewController.swift. 
```swift
   //STT + Weather + TTS
    @IBOutlet weak var speechToTextLabel: UILabel!    
    @IBAction func micButtonTouchedDown(_ sender: Any) {
    }
```

Now you are ready to add the imports:
```swift
//STT
import SpeechToTextV1
//TTS
import TextToSpeechV1
//audio!
import AVFoundation
```
and now you can add the code to the ```micButtonTouchedDown``` function:
```swift
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
```


## Next steps

[And look for further information on using other commands from the serial port - let me know how it worked for you!](http://www.irobot.com/~/media/MainSite/PDFs/About/STEM/Create/create_2_Open_Interface_Spec.pdf)


@blumareks, http://blumareks.blogpost.com

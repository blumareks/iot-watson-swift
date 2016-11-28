#Overview

The previous two labs showed us how easily you can connect an IoT to IBM Bluemix and leverage the Watson analytics and external APIs (Twitter and Twilio). This lab demonstrates a further integration of the IoT with smart devices. This lab will show you how you can connect an iOS app with an IoT with the usage of IBM Watson IoT Platform. Optionally we will start to communicate with a robot connected to Raspberry Pi. We will add Voice User Interface to invoke commands on Raspberry Pi. And optionally Voice UI will be all for hands-free usage of the popular STEM robot – iRobot Create2.

The following graph shows the architecture of this lab. On the left side on the bottom there is a smart device that connects to Watson IoT Platform service hosted on the Bluemix. Then the commands issued from the smart device invoke actions on the Raspberry Pi. Raspberry Pi is optionally connected thru a serial port with iRobot Create2.

![architecture](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/architecture.png)


There will be some code:

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
Finally, you are able to send a command over the created MQTT connection:
iotfSession.send(BEEP_MSG.data(using: String.Encoding.utf8, allowLossyConversion: false),
                             topic: CMD_TOPIC,
                             qos: MQTTQosLevel.exactlyOnce,
                             retain: false)

```

And the final Node.Red flow working with the Rapberry Pi:

![the flow](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/lab3RpiFlow.png)



If you have the robot (iRobot Create2) - you might want to connect it now:

![connecting RPi to iRobot Create2's serial port](https://github.com/blumareks/iot-watson-swift/blob/master/lab3/img/connectRPi2_to_create2.png)

[And look for further information on using other commands from the serial port - let me know how it worked for you!](http://www.irobot.com/~/media/MainSite/PDFs/About/STEM/Create/create_2_Op
en_Interface_Spec.pdf
)

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

func send(_ text: String) {
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .string(text)
        proxy.send(message)
    }
}

class pin{
    var pinNumber = 0
    var pinAnalogValue = 0.0
    var pinDigitalValue = false
}

func setValue(pinGiven: pin, value: Double){
    pinGiven.pinAnalogValue = value
    let hexValue = String(format:"%02X", Int(pinGiven.pinAnalogValue))
    let hexPin = String(format:"%02X", Int(pinGiven.pinNumber))
    let message = ("AA-44-1C-03-02-"+hexPin+"-"+hexValue)
    send(message)
}

func getDigital(pinGiven: pin) -> Bool {
    return pinGiven.pinDigitalValue
}

func getAnalog(pinGiven: pin) -> Double {
    return pinGiven.pinAnalogValue
}
var pin6 = pin()
pin6.pinNumber = 6
var pin9 = pin()
pin9.pinNumber = 9
var pin10 = pin()
pin10.pinNumber = 10
//:#localized(key: "Chapter1Page1_Connection")
//#-code-completion(everything, hide)

setValue(pinGiven: pin6, value: 100)


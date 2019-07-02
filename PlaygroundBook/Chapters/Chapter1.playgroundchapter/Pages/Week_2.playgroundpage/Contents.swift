//#-hidden-code
//Week 2
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
    let hexPin = String(format:"%02X", Int(pinGiven.pinNumber))
    let hexValue = String(format:"%02X", Int(pinGiven.pinAnalogValue))
    let message = ("AA-44-1C-03-02-"+hexPin+"-"+hexValue)
    send(message)
}

func setOn(pinGiven: pin){
    pinGiven.pinDigitalValue = true
    let hexPin = String(format:"%02X", Int(pinGiven.pinNumber))
    let message = ("AA-44-1C-01-02-"+hexPin+"-01")
    send(message)
}

func setOff(pinGiven: pin){
    pinGiven.pinDigitalValue = false
    let hexPin = String(format:"%02X", Int(pinGiven.pinNumber))
    let message = ("AA-44-1C-01-02-"+hexPin+"-00")
    send(message)
}

func isOn(pinGiven: pin) -> Bool {
    return pinGiven.pinDigitalValue
}

func getValue(pinGiven: pin) -> Double {
    return pinGiven.pinAnalogValue
}
var pin4 = pin()
pin4.pinNumber = 4
var pin8 = pin()
pin8.pinNumber = 8
var pin12 = pin()
pin12.pinNumber = 12
var pin6 = pin()
pin6.pinNumber = 6
var pin9 = pin()
pin9.pinNumber = 9
var pin10 = pin()
pin10.pinNumber = 10
//#-end-hidden-code
//:#localized(key: "Chapter1Page4_Week_2")
//#-code-completion(everything, hide)

setValue(pinGiven: pin6, value: 255)
setOn(pinGiven: pin9)


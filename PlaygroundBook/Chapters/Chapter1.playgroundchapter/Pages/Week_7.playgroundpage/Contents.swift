
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
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
    send("AA-44-1C-03-0\(pinGiven.pinNumber)-\(Int(pinGiven.pinAnalogValue))")
}

func getDigital(pinGiven: pin) -> Bool {
    return pinGiven.pinDigitalValue
}

func getAnalog(pinGiven: pin) -> Double {
    return pinGiven.pinAnalogValue
}

//:#localized(key: "Chapter1Page1_Connection")
//#-code-completion(everything, hide)
var pin6 = pin()
pin6.pinNumber = 6
setValue(pinGiven: pin6, value: 100)


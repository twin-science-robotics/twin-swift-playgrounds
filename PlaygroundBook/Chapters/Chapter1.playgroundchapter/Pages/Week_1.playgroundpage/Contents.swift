
//Week 3
import PlaygroundSupport
import UIKit
import Foundation

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

func send(_ text: String) {
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        let message: PlaygroundValue = .string(text)
        proxy.send(message)
    }
}

class pin{
    var pinHex: String
    var pinAnalogValue = 0.0
    var pinDigitalValue = false
    var pinCount = 0
    init (_ isAna: Bool,_ pinNumber: Int){
        pinHex = String(format:"%0X", pinNumber)
    }
}

func setValue(_ pinGiven: pin,_ value: Double){
    pinGiven.pinAnalogValue = value
    let hexValue = String(format:"%02X", Int(pinGiven.pinAnalogValue))
    let message = ("AA-44-1C-03-02-"+pinGiven.pinHex+"-"+hexValue)
    send(message)
}

func setOn(_ pinGiven: pin){
    pinGiven.pinDigitalValue = true
    let message = ("AA-44-1C-01-02-"+pinGiven.pinHex+"-01")
    send(message)
}

func setOff(_ pinGiven: pin){
    pinGiven.pinDigitalValue = false
    let message = ("AA-44-1C-01-02-"+pinGiven.pinHex+"-00")
    send(message)
}

func isOn(_ pinGiven: pin) -> Bool {
    return pinGiven.pinDigitalValue
}

func getValue(_ pinGiven: pin) -> Double {
    return pinGiven.pinAnalogValue
}

func ledLevel(_ pinGiven: pin,_ value:  Double){
    (value<=5) ? setValue(pinGiven, (round(value)-0.5)*50) : setValue(pinGiven, round(value))
}

func buzzerNote(_ pinGiven: pin,_ note: String) {
    var message: String
    switch note {
    case "C4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-00")
    case "D4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-01")
    case "E4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-02")
    case "F4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-03")
    case "G4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-04")
    case "A4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-05")
    case "AS4":
        message = ("AA-44-1C-0F-02-"+pinGiven.pinHex+"-06")
    default:
        message = ("Hello")
        //log("does not match")
    }
    send(message)
}

func buzzerSong(_ pinGiven: pin,_ Song: Int) {
    var message: String
    switch Song {
    case 0:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-00") //StarWars
    case 1:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-01") //GameofThrones
    case 2:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-02") //BirthdaySong
    case 3:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-03") //HarryPotter
    case 4:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-04") //PiratesofCarribean
    case 5:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-05") //SuperMario
    case 6:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-06") //NationalAnthem
    case 7:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-07") //StarWars2
    case 8:
        message = ("AA-44-1C-10-02-"+pinGiven.pinHex+"-08") //Despasito
    default:
        message = ("Hello")
        //log("does not match")
    }
    send(message)
}

func wait(_ duration: Float){
    let result = UInt32(duration*100000)
    usleep(result)
}

func countUpTo(_ pinGiven: pin,_ number: Int){
    for num in 1...number{
        setValue(pinGiven, 255)
        wait(3)
        setValue(pinGiven, 0)
        wait(3)
        pinGiven.pinCount += 1
    }
}

func countDownTo(_ pinGiven: pin,_ number: Int){
    var count = pinGiven.pinCount
    for num in number...count{
        setValue(pinGiven, 255)
        wait(3)
        setValue(pinGiven, 0)
        wait(3)
        pinGiven.pinCount -= 1
    }
}

let pin6 = pin(false, 6)
let pin9 = pin(false, 9)
let pin10 = pin(false, 10)

let pinD4 = pin(false, 4)
let pinD8 = pin(false, 8)
let pinD12 = pin(false, 12)

let pinA6 = pin(true, 6)
let pinA8 = pin(true, 8)
let pinA11 = pin(true, 11)

//:#localized(key: "Chapter1Page5_Week_3")
//#-code-completion(everything, hide)

ledLevel(pin6, 5)
setOn(pin9)
countUpTo(pin10, 5)
countDownTo(pin10, 3)



//#-hidden-code
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

func scale(input: Int) -> Float {
  return Float(input * 255 / 100)
}

func wait(_ duration: Float) {
  let result = UInt32(duration * 1000000)
  usleep(result)
}

func stop() {
  dcMotor(pin6:0, pin10:0)
}

func dcMotor(pin6:Int, pin10:Int) {
  var d6Velocity = pin6
  var d10Velocity = pin10
  if d6Velocity > 100 {
    d6Velocity = 100
  }
  if d10Velocity > 100 {
    d10Velocity = 100
  }
  d10Velocity = lroundf(scale(input: d10Velocity))
  d6Velocity = lroundf(scale(input: d6Velocity))
  
  send([baseMessage, "06", String(format: "%02lX",d6Velocity)].joined(separator: "-"))
  send([baseMessage, "0A", String(format: "%02lX",d10Velocity)].joined(separator: "-"))
}

//#-end-hidden-code
//:#localized(key: "Chapter1Page2_DCMotor")
//#-code-completion(everything, hide)
dcMotor(pin6:/*#-editable-code velocity*/0/*#-end-editable-code*/, pin10:/*#-editable-code velocity*/0/*#-end-editable-code*/ )
wait(/*#-editable-code duration*/0/*#-end-editable-code*/)
stop()

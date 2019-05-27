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

private func colorToHex(_ color: UIColor) -> String? {
  guard let components = color.cgColor.components, components.count >= 3 else {
    return nil
  }
  
  let r = Float(components[0])
  let g = Float(components[1])
  let b = Float(components[2])
  
  return String(format: "%02lX-%02lX-%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
}

func openLed(left: UIColor, middle: UIColor, right: UIColor) {
  guard let first = colorToHex(left), let second = colorToHex(middle), let third = colorToHex(right) else {
    return
  }
  let message = "AA-44-1C-0D-09"
  let sendMessage = [message, first, second, third].joined(separator: "-")
  send(sendMessage)
}

//#-end-hidden-code
//:#localized(key: "Chapter1Page1_Connection")
//#-code-completion(everything, hide)
openLed(left:#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), middle:#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), right:#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))


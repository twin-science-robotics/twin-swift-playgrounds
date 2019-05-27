//
//  ConnectionViewController.swift
//  Book_Sources
//
//  Created by Burak Üstün on 8.04.2019.
//

import Foundation
import UIKit
import PlaygroundSupport

//let debugLabel:UILabel = {
//  let label = UILabel()
//  label.numberOfLines = 0
//  label.textAlignment = .center
//  label.backgroundColor = UIColor(red:0.973, green:0.943, blue:0.879, alpha:1)
//  label.textColor = UIColor(red:0.993, green:0.293, blue:0.147, alpha:1)
//  label.layer.cornerRadius = 20
//  label.clipsToBounds = true
//  return label
//}()

func log(_ text: String) {
//  debugLabel.text = text
}

class MainViewController: UIViewController {
  
  let manager = PlaygroundBluetoothService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 11.0, *) {
      startAvoidingKeyboard()
    }
    configureViews()
  }
  

  func configureViews() {
    guard let bluetoothView = manager.bluetoothView else { return }
    let imageView = UIImageView(image: UIImage(named: "sceneBackground.jpg"))
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    view.addSubview(bluetoothView)
    
    bluetoothView.translatesAutoresizingMaskIntoConstraints = false
    bluetoothView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    bluetoothView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    
//    view.addSubview(debugLabel)
//    if #available(iOS 11.0, *) {
//      let guide = view.safeAreaLayoutGuide
//      debugLabel.translatesAutoresizingMaskIntoConstraints = false
//      debugLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
//      debugLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
//      debugLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -100).isActive = true
//      debugLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
//
//    } else {
//      debugLabel.translatesAutoresizingMaskIntoConstraints = false
//      debugLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
//      debugLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//      debugLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
//      debugLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//    }
  }
  
}

extension MainViewController: PlaygroundLiveViewMessageHandler {
  func receive(_ message: PlaygroundValue) {
    if case let .string(text) = message {
      guard let service = manager.peripheralService else {
        return
      }
      service.write(text)
    }

  }
}

extension UIViewController {
  
  @available(iOS 11.0, *)
  func startAvoidingKeyboard() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)),
                                           name: UIResponder.keyboardWillChangeFrameNotification,
                                           object: nil)
  }
  
  @available(iOS 11.0, *)
  func stopAvoidingKeyboard() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillChangeFrameNotification,
                                              object: nil)
  }
  
  @available(iOS 11.0, *)
  @objc private func _onKeyboardFrameWillChangeNotificationReceived(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
      let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
    }
    
    let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
      let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
      let intersection = safeAreaFrame.intersection(keyboardFrameInView)
      
      let animationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
      let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
      
      UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
        self.additionalSafeAreaInsets.bottom = intersection.height
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
  }

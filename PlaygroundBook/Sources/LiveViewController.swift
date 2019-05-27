//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
  
  let manager = PlaygroundBluetoothService()
  

  public override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onTwinConnect),
                                           name: .twinConnected,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onTwinDisconnect),
                                           name: .twinDisconnected,
                                           object: nil)
  }
  
  public func liveViewMessageConnectionOpened() {
    
  }
  
  
  /*
   public func liveViewMessageConnectionClosed() {
   // Implement this method to be notified when the live view message connection is closed.
   // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
   // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
   }
   */
  
  public func receive(_ message: PlaygroundValue) {
    // Implement this method to receive messages sent from the process running Contents.swift.
    // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
    // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
  }
  
  @objc func onTwinConnect() {
    print("connected")
  }
  
  @objc func onTwinDisconnect() {
    print("disconnected")
  }
  
}


extension Notification.Name {
  static let twinConnected = Notification.Name.init("kTwinConnected")
  static let twinDisconnected = Notification.Name.init("kTwinDisconnected")
}

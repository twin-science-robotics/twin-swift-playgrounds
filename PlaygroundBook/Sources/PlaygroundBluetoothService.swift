//
//  PlaygroundBluetoothService.swift
//  Book_Sources
//
//  Created by Burak Üstün on 6.05.2019.
//

import PlaygroundBluetooth
import CoreBluetooth
import PlaygroundSupport
import Foundation
import UIKit

class PlaygroundBluetoothService: NSObject {
  
  private let BLEServiceUUID = CBUUID(string: "FFE0")
  private let positionCharUUID = CBUUID(string: "FFE1")
  var bluetoothManager: PlaygroundBluetoothCentralManager?
  var currentPeripheral: CBPeripheral?
  var peripheralService: PeripheralService?
  var bluetoothView: PlaygroundBluetoothConnectionView?
  
  override init() {
    super.init()
    initializeCentralManager()
  }
  
  private func initializeCentralManager() {
    bluetoothManager = PlaygroundBluetoothCentralManager(services: [BLEServiceUUID])
    bluetoothManager?.delegate = self
    bluetoothView = PlaygroundBluetoothConnectionView(centralManager: bluetoothManager!, delegate: self, dataSource: self)
  }
  
  func clearDevices() {
    self.bluetoothManager?.cancelPeripheralConnection(self.currentPeripheral)
    self.peripheralService = nil
    self.currentPeripheral = nil
  }
}

extension PlaygroundBluetoothService: PlaygroundBluetoothCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOff:
      clearDevices()
    case .resetting:
      clearDevices()
    default:
      break
    }
  }

  func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didConnectTo peripheral: CBPeripheral) {
    currentPeripheral = peripheral
    peripheralService = PeripheralService(with: peripheral, uuid: positionCharUUID, service: self)
    log("Connected")
    NotificationCenter.default.post(Notification(name: .twinConnected))
  }

  func centralManager(_ centralManager: PlaygroundBluetoothCentralManager, didDisconnectFrom peripheral: CBPeripheral, error: Error?) {
    NotificationCenter.default.post(Notification(name: .twinDisconnected))
    clearDevices()
  }
  
}

extension PlaygroundBluetoothService: PlaygroundBluetoothConnectionViewDelegate, PlaygroundBluetoothConnectionViewDataSource {
  func connectionView(_ connectionView: PlaygroundBluetoothConnectionView,
                      itemForPeripheral peripheral: CBPeripheral,
                      withAdvertisementData advertisementData: [String : Any]?) -> PlaygroundBluetoothConnectionView.Item {
    
    let name = advertisementData?[CBAdvertisementDataLocalNameKey] as? String
    return .init(name: name ?? "Twin", icon: UIImage(named: "twinLogo.png") ?? UIImage(), issueIcon: UIImage())
  }
  
  func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, firmwareUpdateInstructionsFor peripheral: CBPeripheral) -> String {
    return ""
  }
  
  func connectionView(_ connectionView: PlaygroundBluetoothConnectionView, titleFor state: PlaygroundBluetoothConnectionView.State) -> String {
    switch state {
    case .connecting:
      return "Bağlanıyor"
    case .noConnection:
      return "Bağlan"
    case .searchingForPeripherals:
      return "Aranıyor"
    case .selectingPeripherals:
      return "Seç"
    default:
      return "Hata"
    }
  }

}

extension PlaygroundBluetoothCentralManager {
  func cancelPeripheralConnection(_ peripheral: CBPeripheral?) {
    guard let peripheral = peripheral else { return }
    cancelPeripheralConnection(peripheral)
  }
}

//
//  BluetoothService.swift
//  Twin
//
//  Created by Burak Üstün on 15.10.2018.
//  Copyright © 2018 YGA. All rights reserved.
//

import Foundation
import CoreBluetooth
import PlaygroundSupport
import PlaygroundBluetooth

protocol PeripheralServiceDelegate: class {
  func deviceConnected()
}

class PeripheralService: NSObject {
  
  var didUpdatedValue: (([UInt8]) -> Void)?
  var onDeviceConnect: (() -> Void)?
  var peripheral: CBPeripheral?
  var positionCharUUID:CBUUID?
  weak var delegate: PeripheralServiceDelegate?
  weak var service:PlaygroundBluetoothService?
  
  var characteristics: CBCharacteristic? {
    didSet {
      if let positionCharacteristic = characteristics {
        service?.currentPeripheral?.readValue(for: positionCharacteristic)
        service?.currentPeripheral?.setNotifyValue(true, for: positionCharacteristic)
      }
    }
  }
  
  init(with peripheral: CBPeripheral, uuid: CBUUID, service: PlaygroundBluetoothService?) {
    super.init()
    self.peripheral = peripheral
    self.service = service
    self.peripheral?.delegate = self
    self.positionCharUUID = uuid
    startDiscoveringServices()
  }
  
  deinit {
    self.reset()
  }
  
  func startDiscoveringServices() {
    self.peripheral?.discoverServices(nil)
  }
  
  func reset() {
    peripheral = nil
  }
  
}

extension PeripheralService: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if (peripheral != self.peripheral) || (error != nil) || (peripheral.services == nil) || (peripheral.services!.count == 0) {
      return
    }
    peripheral.services?.forEach({peripheral.discoverCharacteristics(nil, for: $0)})
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if (peripheral != self.peripheral) || (error != nil) {
      return
    }
    characteristics = service.characteristics?.filter({$0.uuid == positionCharUUID}).first
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    service?.currentPeripheral?.readValue(for: characteristic)
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    guard let value = characteristic.value else { return }
    let array = [UInt8](value)
    didUpdatedValue?(array)
  }
  
}

extension PeripheralService {
  func write(_ uInt8textArray: String) {
    DispatchQueue.global(qos: .userInitiated).async {
      guard let positionCharacteristic = self.characteristics else {
        log("positionCharacteristic is nil")
        return
      }
      var uIntArray: [UInt8] = []
      uInt8textArray.split(separator: "-").forEach({
        guard let uIntItem = UInt8($0, radix: 16) else {
          log("Error at uInt8textArray")
          return
        }
        uIntArray.append(uIntItem)
      })
      let writeType: CBCharacteristicWriteType = positionCharacteristic.properties.contains(.write) ? .withResponse : .withoutResponse
      self.peripheral?.writeValue(Data(uIntArray), for: positionCharacteristic, type: writeType)
    }
    
  }
  
}

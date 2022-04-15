//
//  BTDevice.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 11/04/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol BTDeviceDelegate: class {
    func deviceConnected()
    func deviceReady()
    func deviceBlinkChanged(value: Bool)
    func deviceSerialChanged(value: String)
    func deviceManufactureChanged(value: String)
    func deviceDeviceNameChanged(value: String)
    func deviceDisconnected()

//    func getBikeIDFromIOT(value: String)
    func countNotify()
    func getFullInfo(value: String)
    func deviceReponseCommand(value: String)
}

class BTDevice: NSObject {
    private let peripheral: CBPeripheral
    private let manager: CBCentralManager
//    private var blinkChar: CBCharacteristic?
//    private var speedChar: CBCharacteristic?
//    private var _blink: Bool = false
//    private var _speed: Int = 5
//    private var _sendString: String = ""
    private var sendCommandChar: CBCharacteristic?
    private var _sendCommandString: String = ""
    var bikeID: String = ""
    private var countNotifyChar: CBCharacteristic?
    
    weak var delegate: BTDeviceDelegate?
    var name: String {
        return peripheral.name ?? "Unknown device"
    }
    var detail: String {
        return peripheral.identifier.description
    }
    
    var sendCommandString: String{
        get{
            return _sendCommandString
        }
        set {
            guard _sendCommandString != newValue else {
                return
            }
            _sendCommandString = newValue
            if let char = sendCommandChar {
                let data = _sendCommandString.data(using: String.Encoding.utf8) ?? Data()
                peripheral.writeValue(data, for: char, type: .withResponse)
            }
        }
    }
    
//    var sendString: String{
//        get {
//            return _sendString
//        }
//        set {
//            guard _sendString != newValue else { return }
//            _sendString = newValue
//            if let char = speedChar {
//                let data = _sendString.data(using:String.Encoding.utf8) ?? Data()
//                peripheral.writeValue(data, for: char, type: .withResponse)
//            }
//        }
//    }
    
    private(set) var serial: String?
    
    init(peripheral: CBPeripheral, manager: CBCentralManager) {
        self.peripheral = peripheral
        self.manager = manager
        super.init()
        self.peripheral.delegate = self
    }
    
    func connect() {
        manager.connect(peripheral, options: nil)
    }
    
    func disconnect() {
        manager.cancelPeripheralConnection(peripheral)
    }
}

extension BTDevice {
    // these are called from BTManager, do not call directly
    
    func connectedCallback() {
        peripheral.discoverServices([BTUUIDs.SERV_UUID_MODMO, BTUUIDs.infoService])
        delegate?.deviceConnected()
    }
    
    func disconnectedCallback() {
        delegate?.deviceDisconnected()
    }
    
    func errorCallback(error: Error?) {
        print("Device: error \(String(describing: error))")
    }
}


extension BTDevice: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Device: discovered services")
        peripheral.services?.forEach {
            print("  \($0)")
            if $0.uuid == BTUUIDs.infoService {
                peripheral.discoverCharacteristics([BTUUIDs.infoManufacturer, BTUUIDs.infoSerial, BTUUIDs.infoName], for: $0)
            }
//            else if $0.uuid == BTUUIDs.SERV_UUID_MODMO {
//                peripheral.discoverCharacteristics([BTUUIDs.CHAR_BIKE_ID_UUID,BTUUIDs.CHAR_BIKE_NOTIFY_UUID], for: $0)
//            }
            else if $0.uuid == BTUUIDs.SERV_UUID_MODMO {
                peripheral.discoverCharacteristics([BTUUIDs.CHAR_APP_CMD_UUID, BTUUIDs.CHAR_DEVICE_RESP_UUID, BTUUIDs.CHAR_BIKE_NOTIFY_UUID], for: $0)
            }
            else {
                peripheral.discoverCharacteristics(nil, for: $0)
            }
            
        }
        print()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Device: discovered characteristics")
        service.characteristics?.forEach {
            print("   \($0)")
            
//            if $0.uuid == BTUUIDs.CHAR_BIKE_ID_UUID {
//                peripheral.readValue(for: $0)
//            } else
            if $0.uuid == BTUUIDs.CHAR_BIKE_NOTIFY_UUID {
                self.countNotifyChar = $0
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            } else if $0.uuid == BTUUIDs.infoSerial {
                peripheral.readValue(for: $0)
            }else if $0.uuid == BTUUIDs.infoManufacturer {
                peripheral.readValue(for: $0)
            }else if $0.uuid == BTUUIDs.infoName {
                peripheral.readValue(for: $0)
            }else if $0.uuid == BTUUIDs.CHAR_APP_CMD_UUID {
                self.sendCommandChar = $0
            }
            else if $0.uuid == BTUUIDs.CHAR_DEVICE_RESP_UUID {
                print("response command = \($0)")
                peripheral.readValue(for: $0)
                peripheral.setNotifyValue(true, for: $0)
            }
        }
        print()
        
        delegate?.deviceReady()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Device: updated value for \(characteristic)")
        
        // get bike ID
//        if characteristic.uuid == BTUUIDs.CHAR_BIKE_ID_UUID, let d = characteristic.value {
//            let str = String(data: d, encoding: .utf8)
//            if self.bikeID == "" {
//                self.bikeID = str ?? ""
//                delegate?.getBikeIDFromIOT(value: self.bikeID)
//            }
//        }
        // get count notifications
        if characteristic.uuid == countNotifyChar?.uuid, let d = characteristic.value {
            let str = String(data: d, encoding: .utf8)
            print("str = \(str)")
            delegate?.getFullInfo(value: str ?? "")
            delegate?.countNotify()
        }
//        if characteristic.uuid == blinkChar?.uuid, let b = characteristic.value?.parseBool() {
//            _blink = b
//            delegate?.deviceBlinkChanged(value: b)
//        }
//        if characteristic.uuid == speedChar?.uuid, let s = characteristic.value?.parseInt() {
//            _speed = Int(s)
//            delegate?.deviceSpeedChanged(value: _speed)
//        }
        if characteristic.uuid == BTUUIDs.infoSerial, let d = characteristic.value {
            serial = String(data: d, encoding: .utf8)
            if let serial = serial {
                delegate?.deviceSerialChanged(value: serial)
            }
        }
        
        if characteristic.uuid == BTUUIDs.infoManufacturer, let d = characteristic.value {
            let str = String(data: d, encoding: .utf8)
            if let infoManufacturer = str {
                delegate?.deviceManufactureChanged(value: infoManufacturer)
            }
        }
        
        if characteristic.uuid == BTUUIDs.infoName, let d = characteristic.value {
            let str = String(data: d, encoding: .utf8)
            if let infoName = str {
                delegate?.deviceDeviceNameChanged(value: infoName)
            }
        }
        
        if characteristic.uuid == BTUUIDs.CHAR_APP_CMD_UUID, let d = characteristic.value {
            let str = String(data: d, encoding: .utf8)
            print("str CHAR_APP_CMD_UUID = \(str)")
        }
        
        if characteristic.uuid == BTUUIDs.CHAR_DEVICE_RESP_UUID, let d = characteristic.value{
            let str = String(data: d, encoding: .utf8)
            print("str = \(str)")
            if let infoResponseCommand = str {
                delegate?.deviceReponseCommand(value: infoResponseCommand)
            }
        }
    }
}



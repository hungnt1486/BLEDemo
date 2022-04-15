//
//  BTUUIDs.swift
//  BLEDemo
//
//  Created by Jindrich Dolezy on 28/11/2018.
//  Copyright © 2018 Dzindra. All rights reserved.
//

import CoreBluetooth


struct BTUUIDs {
    static let SERV_UUID_MODMO = CBUUID(string: "0e210001-f8d9-11ea-adc1-0242ac120002")
    static let CHAR_BIKE_NOTIFY_UUID = CBUUID(string: "0e210004-f8d9-11ea-adc1-0242ac120002")
    
    // backup
    static let CHAR_APP_CMD_UUID = CBUUID(string: "0e210002-f8d9-11ea-adc1-0242ac120002")
    static let CHAR_DEVICE_RESP_UUID = CBUUID(string: "0e210003-f8d9-11ea-adc1-0242ac120002")
    
    static let infoService = CBUUID(string: "180a")
    static let infoManufacturer = CBUUID(string: "2a29")
    static let infoName = CBUUID(string: "2a24")
    static let infoSerial = CBUUID(string: "2a25")
}

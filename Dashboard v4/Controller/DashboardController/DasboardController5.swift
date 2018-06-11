
//  DasboardController5.swift
//  Dashboard 2
//
//  Created by John Allen on 6/1/18.
//  Copyright © 2018 jallen.studios. All rights reserved.


import UIKit
import CoreBluetooth

extension DashBoardController:  CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate  {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Scan for peripherals if BLE is turned on
            central.scanForPeripherals(withServices: nil, options: nil)
            //self.statusLabel.text = "Searching for BLE Devices"
        }
        else {
            // Can have different conditions for all states if needed - print generic message for now
            print("Bluetooth switched off or not initialized")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name
        {
            print(name)
        }
        let deviceName = "LoPy"
        let nameOfDeviceFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? String
        print(nameOfDeviceFound)
        if (nameOfDeviceFound == deviceName) {
            // Update Status Label
            //self.statusLabel.text = "Sensor Tag Found"

            // Stop scanning
            sensorTagPeripheral = peripheral
            //self.centralManager.stopScan()
            // Set as the peripheral to use and establish connection

            self.sensorTagPeripheral!.delegate = (self as CBPeripheralDelegate)
            //self.centralManager.connect(sensorTagPeripheral)
            print("heyyyy")
        }
        else {
           /// self.statusLabel.text = "Sensor Tag NOT Found"
        }
    }
    
    
    // Discover services of the peripheral
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        //statusLabel.text = "Discovering peripheral services"
        peripheral.discoverServices(nil)
    }
    
    
    
    //************
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        //statusLabel.text = "Looking at peripheral services"
        
        
        for service in peripheral.services! {
            print(service)
            
            //       let thisService = service as CBService
            if service.uuid == CBUUID(string: "36353433-3231-3039-3837-363534333231") {
                //                // Discover characteristics of IR Temperature Service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // update status label
        //self.statusLabel.text = "Enabling sensors"
        
        
        
        
        
        // 0x01 data byte to enable sensor
        //        var enableValue = 1
        //        let enablyBytes = NSData(bytes: &enableValue, length: MemoryLayout<UInt8>.size)
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            print(charateristic.uuid)
            let thisCharacteristic = charateristic as CBCharacteristic
            // check for data characteristic
            // if thisCharacteristic.uuid == CBUUID(string: "36353433-3231-3039-3837-363534336261") {
            // Enable Sensor Notification
            print("matey")
            
            if thisCharacteristic.properties.contains(.read) {
                print("\(charateristic.uuid): properties contains .read")
            }
            if thisCharacteristic.properties.contains(.notify) {
                print("\(charateristic.uuid): properties contains .notify")
            }
            if (thisCharacteristic.uuid == CBUUID(string: "36353433-3231-3039-3837-363534336261"))
            {
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
            print("sttdssdsdsdsdf")
            //                self.sensorTagPeripheral.setNotifyValue(true, for: thisCharacteristic)
            //            }
            //            // check for config characteristic
            //            if thisCharacteristic.uuid == CBUUID(string: "36353433-3231-3039-3837-363534336261") {
            //                // Enable Sensor
            //                self.sensorTagPeripheral.writeValue(enablyBytes as Data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
            //            }
            //}
            
        }
    }
    
    
    // Get data values when they are updated
    
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //self.statusLabel.text = "Connected"
        if let stringValue = String(data: Data(characteristic.value!), encoding: .utf8)
        {
            if let num = Double(stringValue) {
            graphView4.update(number: num)
                graphView4.graphName = .wearablevoltage
            }
        }
       
        
    }
    
    
    func dataToSignedBytes16(value : NSData) -> [Int16] {
        let count = value.length
        var array = [Int16](repeating: 0, count: count)
        value.getBytes(&array, length:count * MemoryLayout<Int16>.size)
        return array
    }
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("low")
    }
    
    
    func hexStringtoAscii(_ hexString : String) -> String {
        
        let pattern = "(0x)?([0-9a-f]{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsString = hexString as NSString
        let matches = regex.matches(in: hexString, options: [], range: NSMakeRange(0, nsString.length))
        let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
        }
        return String(characters)
    }
}






//
//  File.swift
//  Covid-CoFight-iOS
//
//  Created by "" on 23/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation
import CoreBluetooth

struct Peripheral {
    var peripheral : CBPeripheral
    var dt : Date
}

protocol BluetoothManagerDelegate : class{
    func bluetoothState(state:CBManagerState)
}

class BluetoothManager : NSObject {
    
    //MARK: - Properties
    private var centralManager : CBCentralManager!
    
    private var peripheralManager : CBPeripheralManager!
    
    weak var delegate: BluetoothManagerDelegate?
    
    //This should be the same as Android's SERVICE_UUID
    private var service = CBUUID(nsuuid: UUID(uuidString: "59BD9B34-A251-45C2-8D55-00807FB49384")!)
    
    //This should be the same as Android's CHAR_UUID
    let characteristic = CBUUID(nsuuid: UUID(uuidString: "68BD9B34-A251-45C2-8D55-00807FB49385")!)

    private var uuid = "0"
    
    var peripherals = [Peripheral]()

    private func initListening() {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:true])
    }
    
    private func initAdvertising() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func start() {
        if let user = User.getLoggedInUser(), user.user_id != 0 {
            self.uuid = String(user.user_id)
        }
        self.initAdvertising()
        self.initListening()
    }
    
}

extension BluetoothManager : CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        self.delegate?.bluetoothState(state: peripheral.state)
        switch peripheral.state {
        case .unknown:
            print("Bluetooth Device is UNKNOWN")
        case .unsupported:
            print("Bluetooth Device is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth Device is UNAUTHORIZED")
        case .resetting:
            print("Bluetooth Device is RESETTING")
        case .poweredOff:
            print("Bluetooth Device is POWERED OFF")
        case .poweredOn:
            print("Bluetooth Device is POWERED ON")
            addServices()
        @unknown default:
            print("Unknown State")
        }
    }
    
    func addServices() {
        let valueData = uuid.data(using: .utf8)
        let myChar2 = CBMutableCharacteristic(type:self.characteristic , properties: [.read], value: valueData, permissions: [.readable])
        let myService = CBMutableService(type: self.service, primary: true)
        myService.characteristics = [myChar2]
        peripheralManager.add(myService)
        startAdvertising()
    }

    func startAdvertising() {
        peripheralManager.startAdvertising([CBAdvertisementDataLocalNameKey : "CovidGuard", CBAdvertisementDataServiceUUIDsKey : [service]])
        //print("Started Advertising")
    }
}

extension BluetoothManager : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [service], options: nil)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral.services == nil {
            peripheral.delegate = self
            peripheral.discoverServices([self.service])
        }
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("did disconnect \(peripheral)")
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        //print(peripheral)
    }
}

extension BluetoothManager : CBPeripheralDelegate {
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Found   : \(peripheral.name ?? "(No name)")")
        var dateMinusOneMinute =  Date()
        dateMinusOneMinute.changeSeconds(by:Int(-ConfigurationController.intervalToSaveEachDevice))
        
        if peripherals.filter({$0.peripheral.identifier == peripheral.identifier && $0.dt > dateMinusOneMinute}).count == 0 {
            peripherals.append(Peripheral(peripheral: peripheral, dt: Date()))
            central.connect(peripheral, options: nil)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if error != nil {
                return ;
            }
           if let service = peripheral.services?.filter({$0.uuid == service}).first {
               peripheral.delegate = self
               peripheral.discoverCharacteristics([characteristic], for: service)
           }
    }
       
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
       if error != nil {
           return
       }
       
       if let characteristic = service.characteristics?.filter({$0.uuid == characteristic}).first {
           peripheral.delegate = self
           peripheral.readValue(for: characteristic)
       }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            return
        }
        guard let data = characteristic.value else { return }
        
        var dateMinusOneMinute =  Date()
        dateMinusOneMinute.changeSeconds(by:Int(-ConfigurationController.intervalToSaveEachDevice))

        if let idStr = String(data: data, encoding: String.Encoding.utf8), let id = Int(idStr) {
            Device.saveDevice(device: Device(user_id:id,ts:Date().secondsSince1970))
        }
        
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

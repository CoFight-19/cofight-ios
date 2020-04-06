//
//  Device.swift
//  Covid-CoFight-iOS
//
//  Created by "" on 24/03/2020.
//  Copyright © 2020 "". All rights reserved.
//

import Foundation

struct Device : Codable {
    var user_id : Int
    var ts : Int64
    
    static func toDeviceJSON(devices:[Device]) -> String? {
        do {
            let devicesJSON = try JSONEncoder().encode(devices)
            if let data = String(data: devicesJSON, encoding: .utf8) {
               return data
            }
        }
        catch {
            return nil
        }
        return nil
    }
    
    static func saveDevice(device:Device) {
        if var devices = Device.getSavedDevices() {
            Device.deleteAllDevices()
            if devices.filter({$0.user_id == device.user_id && $0.ts > (device.ts-ConfigurationController.intervalToSaveEachDevice)}).count == 0 {
                devices.append(device)
            }
            Device.saveDevices(devices: devices)
        }
        else {
            Device.saveDevices(devices: [device])
        }
    }
    
    static func saveDevices(devices:[Device]) {
        do {
            let devicesJSON = try JSONEncoder().encode(devices)
            if let data = String(data: devicesJSON, encoding: .utf8) {
                KeychainController.save(data, for: KeychainKeys.devices.rawValue)
            }
        }
        catch {
            print(error)
        }
    }
    
    static func getSavedDevices() -> [Device]? {
           do {
            if let devicesJSON = KeychainController.retrieveData(for: KeychainKeys.devices.rawValue) {
                    let devices = try JSONDecoder().decode([Device].self, from: Data(devicesJSON.utf8))
                    return devices
                }
               return nil
           }
           catch {
                print(error)
                return nil
           }
    }
    
    static func deleteAllDevices() {
        KeychainController.delete(for: KeychainKeys.devices.rawValue)
    }
    
    static func deleteOldEntries() {
        if let devices = Device.getSavedDevices() {
            Device.deleteAllDevices()
            var currentTS = Date()
            currentTS.changeDays(by: -ConfigurationController.dayToKeepData)
            let lastTsToKeep = currentTS.timeIntervalSince1970
            let newDevices = devices.filter({$0.ts > Int64(lastTsToKeep)})
            Device.saveDevices(devices: newDevices)
        }
    }
}

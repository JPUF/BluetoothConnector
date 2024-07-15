//
//  WidgetBridge.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 12/07/2024.
//

import Foundation
import IOBluetooth
import WidgetKit

struct WidgetBridge {
    
    static let deviceSuiteName = "group.com.jlbennett.ParseBluetoothDevices"
    static private let deviceDataKey = "BluetoothDevices"
    
    static func fetchData() -> [[String: Any]] {
        let defaults = UserDefaults(suiteName: deviceSuiteName)
        guard let deviceData = defaults?.array(forKey: deviceDataKey) as? [[String: Any]] else {
            return []
        }
        return deviceData
    }
    
    static func saveData(deviceData: [[String: Any]]) {
        let defaults = UserDefaults(suiteName: deviceSuiteName)
        defaults?.set(deviceData, forKey: deviceDataKey)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func connectToDevice(deviceAddress: String) {
         print("Connecting to device with address: \(deviceAddress)")

         // Get the list of paired devices
         guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
             print("No devices found")
             return
         }

         print("Device count: \(pairedDevices.count)")
         pairedDevices.forEach {
             print($0.addressString ?? "No address")
         }

         // Find the device with the matching address
         guard let device = pairedDevices.first(where: { $0.addressString == deviceAddress }) else {
             print("Device with address \(deviceAddress) not found")
             return
         }

         print("Connecting to device: \(device.addressString ?? "No address")")
         let result = device.openConnection()
         
         if result == kIOReturnSuccess {
             print("Connected to \(device.name ?? "Unknown")")
             WidgetCenter.shared.reloadAllTimelines()
         } else {
             print("Failed to connect to \(device.name ?? "Unknown")")
         }
     }
}

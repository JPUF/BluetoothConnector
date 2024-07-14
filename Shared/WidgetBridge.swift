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
    
    static func connectToDevice() {
        guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No devices")
            return
        }
        guard let device = pairedDevices.first else {
            print("Device not found")
            return
        }

        let result = device.openConnection()
        if result == kIOReturnSuccess {
            print("Connected to \(device.name ?? "Unknown")")
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            print("Failed to connect to \(device.name ?? "Unknown")")
        }
    }
}

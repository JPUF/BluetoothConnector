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
    private static let bluetoothDevices = BluetoothDevices.shared
    
    private static let deviceSuiteName = "group.com.jlbennett.ParseBluetoothDevices"
    private static let deviceDataKey = "BluetoothDevices"
    
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
    
    static func setDeviceLoading(deviceAddress: String) {
        bluetoothDevices.saveLoadingDevicesToSharedContainer(deviceAddress: deviceAddress)
    }
    
    static func connectToDevice(deviceAddress: String) {
        let result = bluetoothDevices.connectToDevice(deviceAddress:deviceAddress)
        if result == kIOReturnSuccess {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    static func disconnectFromDevice(deviceAddress: String) {
        let result = bluetoothDevices.disconnectFromDevice(deviceAddress:deviceAddress)
        if result == kIOReturnSuccess {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

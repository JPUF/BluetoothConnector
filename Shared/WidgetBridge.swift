//
//  WidgetBridge.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 12/07/2024.
//

import Foundation
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
        reloadWidget()
    }
    
    static func reloadWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

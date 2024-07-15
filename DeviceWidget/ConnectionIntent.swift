//
//  ConnectionIntent.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 12/07/2024.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 14.0, watchOS 9.0, tvOS 16.0, *)
struct ConnectDeviceIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Device Connect"
    static var description = IntentDescription("Manage device connection")
    
    
    init() {
        self.deviceAddress = nil
        self.isDeviceConnected = nil
    }
    
    init(_ deviceAddress: String, _ isDeviceConnected: Bool) {
        self.deviceAddress = deviceAddress
        self.isDeviceConnected = isDeviceConnected
    }
    
    @Parameter(title: "Device Address")
    var deviceAddress: String?
    
    @Parameter(title: "Device Connected")
    var isDeviceConnected: Bool?
    
    func perform() async throws -> some IntentResult {
        guard let deviceAddress = deviceAddress else {
            return .result()
        }
        if isDeviceConnected == true {
            WidgetBridge.disconnectFromDevice(deviceAddress: deviceAddress)
        } else {
            WidgetBridge.connectToDevice(deviceAddress: deviceAddress)
        }
        
        return .result()
    }
}

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
    static var description = IntentDescription("Manager device connection")
    
    func perform() async throws -> some IntentResult {
        WidgetBridge.reloadWidget()
        return .result()
    }
}

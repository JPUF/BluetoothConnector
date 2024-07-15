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
     }
     
     init(_ deviceAddress: String) {
      self.deviceAddress = deviceAddress
     }

     @Parameter(title: "Device Address")
     var deviceAddress: String?

    func perform() async throws -> some IntentResult {
        guard let deviceAddress = deviceAddress else {
            return .result()
        }
                
        WidgetBridge.connectToDevice(deviceAddress: deviceAddress)
        return .result()
   }
}

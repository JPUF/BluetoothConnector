//
//  DeviceRowAppView.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 19/07/2024.
//

import Foundation
import SwiftUI
import IOBluetooth

struct DeviceRowView: View {
    var device: IOBluetoothDevice
    var action: (Bool) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(device.name ?? "Unknown")")
            Text("Connected?: \(device.isConnected() ? "Yes" : "No")")

            if device.isPaired() && device.isConnected() {
                Button(action: {
                    action(false)
                }) {
                    Text("Disconnect")
                }
                .padding(.top, 5)
            } else if device.isPaired() && !device.isConnected() {
                Button(action: {
                    action(true)
                }) {
                    Text("Connect")
                }
                .padding(.top, 5)
            }
        }
        .padding()
    }
}

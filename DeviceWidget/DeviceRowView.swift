//
//  DeviceRowView.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 16/07/2024.
//

import SwiftUI
import AppIntents

struct DeviceRowView: View {
    let device: BluetoothDeviceEntry
    
    var body: some View {
        Button(
            intent: ConnectDeviceIntent(device.address, device.connected)
        ) {
            HStack {
                Image(systemName: device.connected ? "link.circle" : "circle")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(device.connected ? .green : .gray)
                    
                Text(device.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .background(Color.clear)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 4)
    }
}

#Preview {
    DeviceRowView(device: BluetoothDeviceEntry(address: "address", name: "MyHeadphones", connected: true))
}

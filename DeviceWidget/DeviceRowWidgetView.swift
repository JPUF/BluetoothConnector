//
//  DeviceRowView.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 16/07/2024.
//

import SwiftUI
import AppIntents

struct DeviceRowWidgetView: View {
    let device: BluetoothDeviceEntry

    var body: some View {
        Button(
            intent: ConnectDeviceIntent(device.address, device.connected)
        ) {
            HStack {
                Image(systemName: imageName(for: device))
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(imageColor(for: device))
                    
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
    
    private func imageName(for entry: BluetoothDeviceEntry) -> String {
        if entry.loading {
            return "circle"
        } else if entry.connected {
            return "link.circle"
        } else {
            return "circle"
        }
    }
    
    private func imageColor(for entry: BluetoothDeviceEntry) -> Color {
        if entry.loading {
            return .clear
        } else if entry.connected {
            return .green
        } else {
            return .gray
        }
    }
}

#Preview {
    DeviceRowWidgetView(device: BluetoothDeviceEntry(
        address: "address",
        name: "MyHeadphones",
        connected: true,
        loading: false)
    )
}

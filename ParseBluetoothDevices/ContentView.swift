//
//  ContentView.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothDevices = BluetoothDevices.shared
    
    var body: some View {
        VStack {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                bluetoothDevices.fetchPairedDevices()
            }) {
                Text("Reload")
            }
            
            let devices = bluetoothDevices.devices
            
            if devices.isEmpty {
                Text("No devices found")
                    .padding()
            } else {
                List(devices, id: \.addressString) { device in
                    DeviceRowView(device: device) { shouldConnect in
                        if shouldConnect {
                            let _ = bluetoothDevices.connectToDevice(device: device)
                        } else {
                            let _ = bluetoothDevices.disconnectFromDevice(device: device)
                        }
                    }
                }
            }
        }
        .onAppear {
            bluetoothDevices.fetchPairedDevices()
        }
    }
}

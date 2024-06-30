//
//  ContentView.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bluetoothDevices = BluetoothDevices()

    var body: some View {
        VStack {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .padding()

            if bluetoothDevices.devices.isEmpty {
                Text("No devices found")
                    .padding()
            } else {
                List(bluetoothDevices.devices, id: \.addressString) { device in
                    VStack(alignment: .leading) {
                        Text("Name: \(device.name ?? "Unknown")")
                        Text("Paired?: \(device.isPaired() ? "Yes" : "No")")
                        Text("Connected?: \(device.isConnected() ? "Yes" : "No")")
                        
                        // Show the appropriate button based on the connection status
                        if device.isPaired() && device.isConnected() {
                            Button(action: {
                                bluetoothDevices.disconnectFromDevice(device: device)
                            }) {
                                Text("Disconnect")
                            }
                            .padding(.top, 5)
                        } else if device.isPaired() && !device.isConnected() {
                            Button(action: {
                                bluetoothDevices.connectToDevice(device: device)
                            }) {
                                Text("Connect")
                            }
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            bluetoothDevices.fetchPairedDevices()
        }
    }
}

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
                            Button {
                                bluetoothDevices.connectToDevice(device: device)
                            } label : {
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

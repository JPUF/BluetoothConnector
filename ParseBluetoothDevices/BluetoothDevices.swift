//
//  BluetoothDevices.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import IOBluetooth

class BluetoothDevices: ObservableObject {
    @Published var devices: [IOBluetoothDevice] = []

    func fetchPairedDevices() {
        guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No devices")
            return
        }
        self.devices = pairedDevices
    }
    
    func connectToDevice(device: IOBluetoothDevice) {
        print("Connecting to \(device.name ?? "unknown")")
        let result = device.openConnection()
        if(result == kIOReturnSuccess) {
            fetchPairedDevices()
        }
    }
    
    func disconnectFromDevice(device: IOBluetoothDevice) {
        print("Disconnecting from \(device.name ?? "unknown")")
        let result = device.closeConnection()
        fetchPairedDevices()
    }
}

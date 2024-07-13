//
//  BluetoothDevices.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import IOBluetooth
import WidgetKit

class BluetoothDevices: ObservableObject {
    @Published var devices: [IOBluetoothDevice] = []
    
    func fetchPairedDevices() {
        guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No devices")
            return
        }
        self.devices = pairedDevices
        saveDevicesToSharedContainer()
    }
    
    func connectToDevice(device: IOBluetoothDevice) {
        print("Connecting to \(device.name ?? "unknown")")
        let result = device.openConnection()
        if result == kIOReturnSuccess {
            fetchPairedDevices()
        }
    }
    
    func disconnectFromDevice(device: IOBluetoothDevice) {
        print("Disconnecting from \(device.name ?? "unknown")")
        let result = device.closeConnection()
        fetchPairedDevices()
    }
    
    private func saveDevicesToSharedContainer() {
        let deviceData = devices.map { device in
            [
                "name": device.name ?? "Unknown",
                "paired": device.isPaired(),
                "connected": device.isConnected()
            ] as [String : Any]
        }
        WidgetBridge.saveData(deviceData: deviceData)
    }
}

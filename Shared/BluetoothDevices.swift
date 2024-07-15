//
//  BluetoothDevices.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import IOBluetooth
import WidgetKit

class BluetoothDevices: ObservableObject {
    static let shared = BluetoothDevices()
    @Published var devices: [IOBluetoothDevice] = []
    
    private init() {
        // Private initializer to ensure singleton usage
    }
    
    func fetchPairedDevices() {
        guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No devices")
            return
        }
        self.devices = pairedDevices
        saveDevicesToSharedContainer()
    }
    
    func getDeviceByAddress(deviceAddress: String) -> IOBluetoothDevice? {
        if(devices.isEmpty) {
            fetchPairedDevices()
        }

        // Find the device with the matching address
        guard let device = devices.first(where: { $0.addressString == deviceAddress }) else {
            print("Device with address \(deviceAddress) not found")
            return nil
        }
        return device
    }
    
    func connectToDevice(deviceAddress: String) -> IOReturn {
        print("Connecting to device with address: \(deviceAddress)")
        
        guard let device = getDeviceByAddress(deviceAddress: deviceAddress) else {
            return kIOReturnError
        }
        return connectToDevice(device: device)
    }
    
    func connectToDevice(device: IOBluetoothDevice) -> IOReturn {
        print("Connecting to \(device.name ?? "unknown")")
        let result = device.openConnection()
        if result == kIOReturnSuccess {
            fetchPairedDevices()
        }
        return result
    }
    
    func disconnectFromDevice(deviceAddress: String) -> IOReturn {
        print("Disconnecting from device with address: \(deviceAddress)")
        guard let device = getDeviceByAddress(deviceAddress: deviceAddress) else {
            return kIOReturnError
        }
        return disconnectFromDevice(device: device)
    }
    
    func disconnectFromDevice(device: IOBluetoothDevice) -> IOReturn {
        print("Disconnecting from \(device.name ?? "unknown")")
        let result = device.closeConnection()
        fetchPairedDevices()
        return result
    }
    
    private func saveDevicesToSharedContainer() {
        let deviceData = devices.map { device in
            [
                "address": device.addressString ?? "",
                "name": device.name ?? "Unknown",
                "paired": device.isPaired(),
                "connected": device.isConnected()
            ] as [String : Any]
        }
        WidgetBridge.saveData(deviceData: deviceData)
    }
}

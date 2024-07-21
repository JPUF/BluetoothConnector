//
//  BluetoothDevices.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 30/06/2024.
//

import IOBluetooth
import WidgetKit

class BluetoothDevices: ObservableObject, BluetoothConnectionDelegate {
    
    static let shared = BluetoothDevices()
    @Published var devices: [IOBluetoothDevice] = []
    
    private var bluetoothConnection: BluetoothConnection?
    
    private init() {
        // Private initializer to ensure singleton usage
        registerForNotifications()
        fetchPairedDevices()
        bluetoothConnection = BluetoothConnection(delegate: self)
    }
    
    func fetchPairedDevices() {
        guard let pairedDevices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            print("No devices")
            return
        }
        for device in pairedDevices {
            print("fetched device: \(device.name ?? ""), connected: \(device.isConnected())")
        }
        DispatchQueue.main.async {
            self.devices = pairedDevices
            self.saveDevicesToSharedContainer()
        }
    }
    
    func getDeviceByAddress(deviceAddress: String) -> IOBluetoothDevice? {
        if devices.isEmpty {
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
        
        let timeoutInterval: TimeInterval = 4.0
        var connectionResult: IOReturn = kIOReturnTimeout
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            let result = device.openConnection()
            connectionResult = result
            semaphore.signal()
        }
        
        let timeoutResult = semaphore.wait(timeout: .now() + timeoutInterval)
        if timeoutResult == .timedOut {
            print("Connection to \(device.name ?? "unknown") timed out")
            // Optionally close the connection if it partially opened
            device.closeConnection()
        } else {
            print("Connection result for \(device.name ?? "unknown"): \(connectionResult)")
        }
        
        fetchPairedDevices()
        return connectionResult
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
        return device.closeConnection()
    }
    
    private func saveDevicesToSharedContainer() {
        let deviceData = devices.map { device in
            [
                "address": device.addressString ?? "",
                "name": device.name ?? "Unknown",
                "connected": device.isConnected(),
                "loading": false,
            ] as [String : Any]
        }
        WidgetBridge.saveData(deviceData: deviceData)
    }
    
    func saveLoadingDevicesToSharedContainer(deviceAddress: String) {
        print("Loading device: \(deviceAddress)")
        let deviceData = devices.map { device in
            [
                "address": device.addressString ?? "",
                "name": device.name ?? "Unknown",
                "connected": device.isConnected(),
                "loading": device.addressString ?? "" == deviceAddress ? true : false,
            ] as [String : Any]
        }
        WidgetBridge.saveData(deviceData: deviceData)
    }
    
    
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnected(_:)), name: NSNotification.Name(rawValue: kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisconnected(_:)), name: NSNotification.Name(rawValue: kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
    }
    
    @objc private func deviceConnected(_ notification: Notification) {
        print("Device connected")
        if let device = notification.object as? IOBluetoothDevice {
            print("Device connected: \(device.name ?? "Unknown")")
            fetchPairedDevices()
        }
    }
    
    @objc private func deviceDisconnected(_ notification: Notification) {
        if let device = notification.object as? IOBluetoothDevice {
            print("Device disconnected: \(device.name ?? "Unknown")")
            fetchPairedDevices()
        }
    }
    
    func onDeviceConnectivityChanged() {
        fetchPairedDevices()
    }
}

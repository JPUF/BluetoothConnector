//
//  BluetoothConnection.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 18/07/2024.
//

import Foundation
import IOBluetooth

protocol BluetoothConnectionDelegate : AnyObject {
    func onDeviceConnectivityChanged()
}

@objc class BluetoothConnection: NSObject {
    
    weak var delegate: BluetoothConnectionDelegate?
    
    init(delegate: BluetoothConnectionDelegate) {
            self.delegate = delegate
            super.init()
            IOBluetoothDevice.register(forConnectNotifications: self, selector: #selector(deviceIsConnected(notification:device:)))
        }

    @objc func deviceIsConnected(notification: IOBluetoothUserNotification, device: IOBluetoothDevice) {
        print("\(device.name ?? "Unknown") (\(device.addressString ?? "Unknown")) connected")
        delegate?.onDeviceConnectivityChanged()
        device.register(forDisconnectNotification: self, selector: #selector(deviceDidDisconnect(notification:device:)))
    }

    @objc func deviceDidDisconnect(notification: IOBluetoothUserNotification, device: IOBluetoothDevice) {
        print("\(device.name ?? "Unknown") (\(device.addressString ?? "Unknown")) disconnected")
        delegate?.onDeviceConnectivityChanged()
    }
}

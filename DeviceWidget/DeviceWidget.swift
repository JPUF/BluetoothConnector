//
//  DeviceWidget.swift
//  DeviceWidget
//
//  Created by James BENNETT on 02/07/2024.
//

import WidgetKit
import SwiftUI
import IOBluetooth
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), devices: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), devices: fetchBluetoothDevicesFromSharedContainer())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, devices: fetchBluetoothDevicesFromSharedContainer())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchBluetoothDevicesFromSharedContainer() -> [BluetoothDeviceEntry] {
        let deviceData = WidgetBridge.fetchData()

        return deviceData.map { data in
            BluetoothDeviceEntry(
                address: data["address"] as? String ?? "",
                name: data["name"] as? String ?? "Unknown",
                paired: data["paired"] as? Bool ?? false,
                connected: data["connected"] as? Bool ?? false
            )
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let devices: [BluetoothDeviceEntry]
}

struct BluetoothDeviceEntry {
    let address: String
    let name: String
    let paired: Bool
    let connected: Bool
}

struct DeviceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Bluetooth Devices")
                .font(.headline)
            ForEach(entry.devices, id: \.name) { device in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Name: \(device.name)")
                        Text("Paired: \(device.paired ? "Yes" : "No")")
                        Text("Connected: \(device.connected ? "Yes" : "No")")
                    }
                    Button(
                        intent: ConnectDeviceIntent(device.address)
                    ) {
                        Text(device.connected ? "Disconnect" : "Connect")
                    }
                }
                .padding(.vertical, 2)
            }
            .padding()
        }
        .padding()
    }
}

struct DeviceWidget: Widget {
    let kind: String = "DeviceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeviceWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Bluetooth Device Widget")
        .description("Displays the status of paired Bluetooth devices.")
    }
}

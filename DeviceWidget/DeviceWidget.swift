//
//  DeviceWidget.swift
//  DeviceWidget
//
//  Created by James BENNETT on 02/07/2024.
//

import WidgetKit
import SwiftUI
import IOBluetooth

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), devices: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("getSnapshot")
        let entry = SimpleEntry(date: Date(), devices: fetchBluetoothDevicesFromSharedContainer())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("getTimeline")
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, devices: fetchBluetoothDevicesFromSharedContainer())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchBluetoothDevicesFromSharedContainer() -> [BluetoothDeviceEntry] {
        let defaults = UserDefaults(suiteName: "group.com.jlbennett.ParseBluetoothDevices")
        let someData = defaults?.array(forKey: "BluetoothDevices")
        print("weird devices \(someData?.count ?? -1)")
        guard let deviceData = defaults?.array(forKey: "BluetoothDevices") as? [[String: Any]] else {
            print("no devices")
            return []
        }
        
        print("some devices")

        return deviceData.map { data in
            BluetoothDeviceEntry(
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
                VStack(alignment: .leading) {
                    Text("Name: \(device.name)")
                    Text("Paired: \(device.paired ? "Yes" : "No")")
                    Text("Connected: \(device.connected ? "Yes" : "No")")
                }
                .padding(.vertical, 2)
            }
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

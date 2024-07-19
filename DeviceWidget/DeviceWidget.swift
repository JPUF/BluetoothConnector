//
//  DeviceWidget.swift
//  DeviceWidget
//
//  Created by James BENNETT on 02/07/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), devices: [], maxDeviceCount: maxVisibleDevices(for: context))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let maxDevices = maxVisibleDevices(for: context)
        let entry = SimpleEntry(date: Date(), devices: fetchBluetoothDevicesFromSharedContainer(), maxDeviceCount: maxDevices)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let maxDevices = maxVisibleDevices(for: context)
        let entry = SimpleEntry(date: currentDate, devices: fetchBluetoothDevicesFromSharedContainer(), maxDeviceCount: maxDevices)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func fetchBluetoothDevicesFromSharedContainer() -> [BluetoothDeviceEntry] {
        let deviceData = WidgetBridge.fetchData()
        
        return deviceData.map { data in
            BluetoothDeviceEntry(
                address: data["address"] as? String ?? "",
                name: data["name"] as? String ?? "Unknown",
                connected: data["connected"] as? Bool ?? false,
                loading: data["loading"] as? Bool ?? false
            )
        }
    }
    
    private func maxVisibleDevices(for context: Context) -> Int {
        switch context.family {
        case .systemSmall, .systemMedium:
            return 3
        default:
            return 7
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let devices: [BluetoothDeviceEntry]
    let maxDeviceCount: Int
}



@available(macOS 14.0, *)
struct DeviceWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Bluetooth Devices")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 4)
            
            let devicesToDisplay = entry.devices.prefix(entry.maxDeviceCount)
            ForEach(devicesToDisplay.indices, id: \.self) { index in
                VStack {
                    DeviceRowWidgetView(device: devicesToDisplay[index])
                    
                    if index != devicesToDisplay.indices.last {
                        Divider()
                            .padding(.leading, 32)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
    }
}

struct DeviceWidget: Widget {
    let kind: String = "DeviceWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeviceWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Bluetooth Device Widget")
        .description("Displays the status of paired Bluetooth devices.")
    }
}

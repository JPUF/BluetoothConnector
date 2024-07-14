//
//  DeviceIntentParam.swift
//  ParseBluetoothDevices
//
//  Created by James BENNETT on 14/07/2024.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 14.0, watchOS 9.0, tvOS 16.0, *)
struct DeviceAddressEntity: AppEntity {
    var displayRepresentation: DisplayRepresentation {
            DisplayRepresentation(title: .init(stringLiteral: address))
        }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Device Address"
    }
    
    var id: UUID = UUID()
    var address: String

    static var defaultQuery = DeviceAddressQuery()
}

struct DeviceAddressQuery: EntityQuery {
    func entities(for identifiers: [UUID]) -> [DeviceAddressEntity] {
        return []
    }
    
    func suggestedEntities() -> [DeviceAddressEntity] {
        return []
    }
}

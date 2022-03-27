//
//  Desktop.swift
//
//  Created by Veronika Babii on 31.10.2021.
//

import Foundation

class Desktop: Device {
    
    // MARK: - Properties
    
    var subDeviceIds: [String]?
    
    override var description: String {
        let id = "id: \(id), "
        let altName = "\(type) \(self.id)"
        let name = "name: \(name ?? altName), "
        let type = "type: \(type), "
        let subDeviceIds = "subDeviceIds: \(subDeviceIds ?? [])"
        return id + name + type + subDeviceIds
    }
    
    // MARK: - Init
    
    init(id: String, name: String?, type: DeviceType, subDeviceIds: [String]?) {
        super.init(id: id, name: name, type: type, desktopId: nil)
        self.subDeviceIds = subDeviceIds
    }
    
    // MARK: - Methods
    
    override func playLights(of light: Light) {
        // Get devices from subDevicesIds.
        subDeviceIds?.forEach { id in
            // Fire up each device's playLights method.
            DeviceManager.shared.devices.filter({ $0.id == id }).forEach { $0.playLights(of: light) }
        }
    }
}

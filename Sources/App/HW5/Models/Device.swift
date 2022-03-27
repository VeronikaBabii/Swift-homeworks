//
//  Device.swift
//
//  Created by Veronika Babii on 31.10.2021.
//

import Foundation

enum DeviceType: String {
    case lamp, mouse, cooler, phones, desktop
}

class Device {
    
    // MARK: - Properties
    
    var id: String
    var name: String?
    var type: DeviceType
    var desktopId: String?
    var lights = [Light()]
    
    var description: String {
        let id = "id: \(id), "
        let altName = "\(type) \(self.id)"
        let name = "name: \(name ?? altName), "
        let type = "type: \(type), "
        let lights = "lights: \(lights.map { $0.description }), "
        let desktopId = "desktopId: \(desktopId ?? "nil")"
        return id + name + type + lights + desktopId
    }
    
    // MARK: - Init
    
    init(id: String, name: String?, type: DeviceType, lights: [Light], desktopId: String?) {
        self.id = id
        self.name = name ?? "\(type) \(id)"
        self.type = type
        self.lights = lights
        
        if let desktopId = desktopId {
            self.desktopId = desktopId
        }
    }
    
    init(id: String, name: String?, type: DeviceType, desktopId: String?) {
        self.id = id
        self.name = name ?? "\(type) \(id)"
        self.type = type
        
        if let desktopId = desktopId {
            self.desktopId = desktopId
        }
    }
    
    // MARK: - Methods
    
    func playLights(of light: Light) {
        lights.append(light)
    }
}

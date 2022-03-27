//
//  DeviceManager.swift
//
//  Created by Veronika Babii on 31.10.2021.
//

import Foundation

class DeviceManager {
    
    static let shared = DeviceManager()
    var devices = [Device]()
    
    // 1
    func addDevice(_ device: Device) -> Int {
        // Check for existing id.
        if devices.filter({ $0.id == device.id }).count != 0 || device.id == "" || device.id.contains(" ") {
            print("Bad device id")
            return 400
        }
        
        // Check name.
        if device.name == "" || device.name == " " {
            print("Bad device name")
            return 400
        }
        
        // Check desktop id.
        if device.desktopId != nil && devices.filter({ $0.type == .desktop }).filter({ $0.id == device.desktopId }).count == 0 {
            print("Bad desktop id")
            return 400
        }
        
        // Desktop cannot have desktopId.
        if device.type == .desktop && device.desktopId != nil {
            print("Desktop cannot have desktopId")
            return 400
        }
        
        if device.type == .desktop {
            devices.append(Desktop(id: device.id, name: device.name, type: .desktop, subDeviceIds: []))
        } else {
            devices.append(device)
            
            // Search for that desktop by id.
            if let id = device.desktopId,
               let desktopIndex = devices.firstIndex(where: { $0.id == id }) {
                
                // Add this device to subDeviceIds of that desktop.
                if let desktop = devices[desktopIndex] as? Desktop {
                    desktop.subDeviceIds?.append(device.id)
                    devices[desktopIndex] = desktop
                }
            }
        }
        
        print("Devices after addition:")
        DeviceManager.shared.devices.forEach({ print($0.description) })
        
        return 200
    }
    
    // 2
    func removeDevice(with id: String) -> Int {
        if devices.filter({ $0.id == id }).count == 0 {
            print("No such device id")
            return 400
        }
        
        devices.removeAll { $0.id == id }
        
        // Remove this device from subdevices of all desktops.
        devices.filter({ $0.type == .desktop}).forEach { device in
            if let desktop = device as? Desktop {
                desktop.subDeviceIds?.removeAll(where: { $0 == id })
            }
        }
        
        // Remove this device from subdevices of that desktop.
        if let deviceIndex = devices.firstIndex(where: { $0.id == id }),
           let desktopIndex = devices.firstIndex(where: { $0.desktopId == devices[deviceIndex].desktopId }),
           let desktop = devices[desktopIndex] as? Desktop {
            desktop.subDeviceIds?.removeAll { $0 == id }
        }
        
        // Remove this id from all devices' desktopId, for all devices with this id as desktopId.
        for (index, _) in devices.filter({ $0.desktopId == id }).enumerated() {
            devices[index].desktopId = nil
        }
        
        print("Devices after removal:")
        DeviceManager.shared.devices.forEach({ print($0.description) })
        
        return 200
    }
    
    // 3
    func turnLight(_ isLightOn: Bool, for id: String) -> Int {
        guard let deviceIndex = devices.firstIndex(where: { $0.id == id }) else {
            print("No such device id")
            return 400
        }
        
        let device = devices[deviceIndex]
        
        // For each light of device set lightOn property to isLightOn.
        device.lights.forEach({ $0.lightOn = isLightOn })
        
        // If device is desktop - for each light of each device.
        if device.type == .desktop {
            if let desktop = device as? Desktop {
                desktop.subDeviceIds?.forEach { subDeviceId in
                    
                    // Find device with id that is subDeviceId.
                    for device in devices where device.id == subDeviceId {
                        device.lights.forEach { $0.lightOn = isLightOn }
                    }
                }
            }
        }
        
        print("Devices after turning on lights:")
        devices.forEach({ print($0.description) })
        
        return 200
    }
    
    // 4
    func playLight(ligth newLight: Light?, for id: String) -> Int {
        guard let deviceIndex = devices.firstIndex(where: { $0.id == id }) else {
            print("No such device id")
            return 400
        }
        
        // Validate new light.
        guard let light = newLight else {
            print("Error while creating light")
            return 400
        }
        
        // Fire up device's playLights method.
        let device = devices[deviceIndex]
        if device.type == .desktop {
            let desktop = device as? Desktop
            desktop?.playLights(of: light)
        } else {
            devices[deviceIndex].playLights(of: light)
        }
        
        print("Devices after playing lights:")
        devices.forEach({ print($0.description) })
        
        return 200
    }
    
    // 5
    func getDevicesDTO() -> [DeviceDossierDto] {
        var dossier = [DeviceDossierDto]()
        
        // Get each device as DeviceDossierDto.
        for device in devices {
            var lights = [LightDTO]()
            
            for effect in device.lights {
                var speed: String?
                if let temp = effect.speed {
                    speed = String(temp)
                } else {
                    speed = nil
                }
                
                let type = effect.type.rawValue
                let direction = effect.direction?.rawValue
                let light = LightDTO(lightOn: effect.lightOn, effect: type, colors: effect.colours, speed: speed, direction: direction)
                
                lights.append(light)
            }
            
            let type = device.type.rawValue
            let id = device.id
            let name = device.name ?? "\(type) \(id)"
            
            if device.type == .desktop {
                if let desktop = device as? Desktop {
                    let elem = DeviceDossierDto(id: id, name: name, type: type, desktopId: nil, subdeviceIds: desktop.subDeviceIds, lights: lights)
                    dossier.append(elem)
                }
            } else {
                let elem = DeviceDossierDto(id: id, name: name, type: type, desktopId: device.desktopId, subdeviceIds: nil, lights: lights)
                dossier.append(elem)
            }
        }
        return dossier
    }
}

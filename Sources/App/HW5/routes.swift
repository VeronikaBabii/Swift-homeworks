import Vapor

func routes(_ app: Application) throws {

    // 1: Add device.
    app.post("device") { req -> Int in
        let id = try req.content.get(String.self, at: "id")
        let name = try? req.content.get(String.self, at: "custom_name")
        let deviceType = try req.content.get(String.self, at: "type")
        let desktopId = try? req.content.get(String.self, at: "desktop_id")
        
        // Check type to be from deviceType enum.
        guard let type = DeviceType(rawValue: deviceType) else {
            print("No such device type")
            return 400
        }
        
        let newDevice = Device(id: id, name: name, type: type, desktopId: desktopId)
        let added = DeviceManager.shared.addDevice(newDevice)
        return added
    }
    
    // 2: Remove device by id.
    app.delete("device") { req -> Int in
        let id = try req.content.get(String.self, at: "id")
        
        return DeviceManager.shared.removeDevice(with: id)
    }

    // 3: Turn on/off lights for device with id.
    app.put("device", "light") { req -> Int in
        let id = try req.content.get(String.self, at: "id")
        let isLightOn = try req.content.get(Bool.self, at: "on")
        
        return DeviceManager.shared.turnLight(isLightOn, for: id)
    }

    // 4: Play light on device = add new light to array of lights.
    app.put("device", "effect") { req -> Int in
        let id = try req.content.get(String.self, at: "id")
        let type = try req.content.get(String.self, at: "effect_name")
        let colors = try? req.content.get([String]?.self, at: "colors")
        let speed = try? req.content.get(String?.self, at: "speed")
        let direction = try? req.content.get(String?.self, at: "direction")

        let newLight = Light(type: type, colours: colors, speed: speed, direction: direction, lightOn: false)
        return DeviceManager.shared.playLight(ligth: newLight, for: id)
    }

    // 5: Get DeviceDossierDto for each device.
    app.get("devices") { req -> [DeviceDossierDto] in
        return DeviceManager.shared.getDevicesDTO()
    }
}

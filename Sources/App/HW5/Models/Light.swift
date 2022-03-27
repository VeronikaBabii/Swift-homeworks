//
//  Light.swift
//
//  Created by Veronika Babii on 31.10.2021.
//

import Foundation

enum LightType: String {
    case staticLight, blinking, waving
}

enum LightDirection: String {
    case up, down, right, left
}

class Light {
    
    // MARK: - Properties
    
    var type: LightType = .staticLight
    var colours: [String] = ["#FFFFFF"]
    var speed: Double?
    var direction: LightDirection?
    var lightOn: Bool = false
    
    var description: String {
        let type = "type: \(type), "
        let colours = "colours: \(colours), "
        let speed = "speed: \(speed ?? nil), "
        let direction = "direction: \(direction?.rawValue), "
        let lightOn = "lightOn: \(lightOn);"
        return type + colours + speed + direction + lightOn
    }
    
    // MARK: - Init
    
    init() { }
    
    init?(type: String, colours: [String]?, speed: String? = nil, direction: String? = nil, lightOn: Bool) {
        
        guard let type = LightType(rawValue: type) else { print("No such light type"); return nil }
        self.type = type
        
        // Colors.
        if let colours = colours {
            if colours.filter({ $0.validateHexColorStr() == false }).count != 0 { print("Bad hex color"); return nil }
            self.colours = colours
        }
        
        // Speed.
        if speed == nil && (type == LightType.blinking || type == LightType.waving) { print("No speed"); return nil }
        
        if let speed = speed {
            guard let speed = Double(speed), speed >= 0.0 else { print("Bad speed"); return nil  }
            if type != LightType.blinking && type != LightType.waving { print("Speed fail"); return nil }
            self.speed = speed
        }
        
        // Direction.
        if direction == nil && type == LightType.waving { print("No direction"); return nil }
        if direction != nil && type != LightType.waving { print("Direction fail"); return nil }
        if let direction = direction {
            guard let direction = LightDirection(rawValue: direction) else { print("No such light direction"); return nil }
            self.direction = direction
        }
        
        self.lightOn = lightOn
    }
}

// MARK: - Extensions

extension String {
    func validateHexColorStr() -> Bool {
        if self.isEmpty || self.count != 7 || self.first != "#" {
            return false
        }
        return true
    }
}

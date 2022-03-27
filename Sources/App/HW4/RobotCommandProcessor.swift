//
//  RobotCommandProcessor.swift
//
//  Created by Veronika Babii on 07.10.2021.
//

import Foundation

class RobotCommandProcessor {
    
    var robotCommands = [Command]()
    var programLog = [String]()
    
    // 1: Get all commands as arrows.
    func getCommandsAsArrows() -> [String] {
        var arrows = [String]()
        robotCommands.forEach { arrows.append($0.getArrow()) }
        return arrows
    }
    
    // 2.1: Add command at specific index.
    func addCommand(command newCommand: String, at index: Int) -> Int {
        guard let command = validateCommand(newCommand) else {
            print("Bad command")
            return 400
        }
        
        if (index == -1 || robotCommands.count == 0) {
            robotCommands.append(command)
        } else if (index >= 0 && index <= robotCommands.count) {
            robotCommands.insert(command, at: index)
        } else {
            print("Bad index")
            return 400
        }
        
        print(robotCommands)
        programLog.append("Added command *\(newCommand)* at \(index)")
        
        return 200
    }
    
    private func validateCommand(_ commandStr: String) -> Command? {
        let components = commandStr.components(separatedBy: " ")
        if components.count != 2 {
            print("Not 2 elements separated by space")
            return nil
        }
        
        // Check command name to be a string from RobotCommands.
        var availableCommandsNames = [String]()
        
        let elm = RobotCommands()
        let mirror = Mirror(reflecting: elm)
        for child in mirror.children  {
            availableCommandsNames.append(child.label ?? "")
        }
        
        if !availableCommandsNames.contains(components[0]) {
            print("RobotCommands doesn't contain specified command")
            return nil
        }
        let commandName = components[0]
        
        // Check command value to be float that is bigger than 0.
        guard let commandValue: Float = Float(components[1]),
              commandValue >= 0.0 else {
            print("Bad command value")
            return nil
        }
        
        if (commandName == "left" || commandName == "right") {
            if (commandValue >= 360) || !(commandValue.truncatingRemainder(dividingBy: 90) == 0) {
                print("Bad angle")
                return nil
            }
        }
        return Command(name: commandName, value: commandValue)
    }
    
    // 2.2: Detele command at specific index.
    func deleteCommand(at index: Int) -> Int {
        if (index < 0 || index > robotCommands.count) {
            print("Bad index")
            return 400
        }
        
        robotCommands.remove(at: index)
        print(robotCommands)
        
        programLog.append("Deleted command at \(index) index")
        
        return 200
    }
    
    // 3: Get final position angle.
    func getFinalPosAngle() -> String {
        let rightLeftCommands = robotCommands.filter { $0.name == "right" || $0.name == "left"}
        var angle = Float()
        
        rightLeftCommands.forEach { command in
            if command.name == "right" {
                angle += command.value
            } else if command.name == "left" {
                angle -= command.value
                
                switch angle {
                case -270.0: angle = 90.0
                case -180.0: angle = 180.0
                case -90.0: angle = 270.0
                default: break;
                }
            }
        }
        var resAngle = String()
        switch angle {
        case 0: resAngle = Angles.up.arrow
        case 90: resAngle = Angles.right.arrow
        case 180: resAngle = Angles.down.arrow
        case 270: resAngle = Angles.left.arrow
        default: return ""
        }
        programLog.append("Final position angle: \(resAngle)")
        return resAngle
    }
    
    // 4: Get length of forward commands.
    func getTotalRouteLength() -> String {
        let forwardCommands = robotCommands.filter { $0.name == "forward" }
        let sum = forwardCommands.reduce(0, { $0 + $1.value })
        let length = Length(value: sum)
        let res = "\(Angles.up.arrow)(\(length.distance))"
        programLog.append("Total route length: \(res)")
        return res
    }
    
    // 5: Get coordinates of final position.
    func getFinalCoords() -> [Int] {
        let commands = robotCommands
        var currHeading = String()
        var coords = Coordinates(x: 0, y: 0)

        for (i, command) in commands.enumerated() {
            if (command.name == "right" || command.name == "left") {
                if (i > 0) {
                    currHeading = getHeading(currHeading, command)
                } else {
                    currHeading = command.checkAngle()
                }
            } else if command.name == "forward" {
                let value = command.convertValueToCm()
                switch currHeading {
                case Angles.right.arrow:
                    coords.x += value
                case Angles.left.arrow:
                    coords.x -= value
                case Angles.up.arrow:
                    coords.y += value
                case Angles.down.arrow:
                    coords.y -= value
                default:
                    break;
                }
            }
        }
        let coord = [coords.x, coords.y]
        programLog.append("Final coord: \(coord)")
        return coord
    }
    
    private func getHeading(_ currHeading: String, _ command: Command) -> String {
        let currAngle = Angle(arrow: currHeading)
        switch command.value {
        case 90:
            return currAngle.turn90(direction: command.name)
        case 180:
            return currAngle.symmetric
        case 270:
            let temp = currAngle.turn90(direction: command.name)
            return Angle(arrow: temp).symmetric
        default:
            return ""
        }
    }
}

//
//  Person.swift
//
//  Created by Veronika Babii on 14.11.2021.
//

import Foundation
import Vapor

struct Person: Codable, Content {
    let name: String
    let age: Int
    let occupation: Occupation
    let hasChronicalIllness: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, age, occupation
        case hasChronicalIllness = "has_chronical_illness"
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        if lhs.name == rhs.name &&
            lhs.age == rhs.age &&
            lhs.hasChronicalIllness == rhs.hasChronicalIllness &&
            lhs.occupation.rawValue == rhs.occupation.rawValue
        {
            return true
        }
        return false
    }
    
    static func compareByPriority(person1: Person, person2: Person) -> Bool {
        if person1.getPriorityAtQueue() < person2.getPriorityAtQueue() {
            return true
        }
        return false
    }
    
    func getPriorityAtQueue() -> Int {
        if occupation == .medWorkerCovid || occupation == .elderlyWorker || occupation == .soldiersAtWar {
            return 1
        }
        if occupation == .medWorker || age >= 80 || occupation == .socialWorkers {
            return 2
        }
        if 65...79 ~= age || occupation == .criticalSecurityService || occupation == .education {
            return 3
        }
        if 60...64 ~= age || hasChronicalIllness == true || occupation == .prisonWorker || occupation == .prisoner {
            return 4
        }
        if occupation == .other && age >= 18 {
            return 5
        }
        return 6
    }
}

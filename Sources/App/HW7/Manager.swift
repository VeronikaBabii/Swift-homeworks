//
//  Manager.swift
//
//  Created by Veronika Babii on 14.11.2021.
//

import Foundation

class Manager {
    static let shared = Manager()
    private var peopleRegistry = PriorityQueueArray(sort: Person.compareByPriority, elements: [])
    
    public func addPerson(_ person: Person) -> Bool {
        let success = peopleRegistry.enqueue(person)
        return success
    }
    
    public func getAllPeople() -> [Person] {
        return peopleRegistry.getElements()
    }
}

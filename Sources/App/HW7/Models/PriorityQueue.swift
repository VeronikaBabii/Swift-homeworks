//
//  PriorityQueue.swift
//
//  Created by Veronika Babii on 16.11.2021.
//

import Foundation

public struct PriorityQueueArray<T: Equatable>: Queue {
    
    // MARK: - Properties
    
    private var elements: [T] = []
    
    private let sort: (Element, Element) -> Bool
    
    public var isEmpty: Bool { elements.isEmpty }
    
    public var peek: T? { elements.first }
    
    public var count: Int { return elements.count }
    
    // MARK: - Init
    
    public init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        self.elements.sort(by: sort)
    }
    
    // MARK: - Methods
    
    public mutating func enqueue(_ element: T) -> Bool {
        for (index, otherElement) in elements.enumerated() {
            if sort(element, otherElement) {
                elements.insert(element, at: index)
                return true
            }
        }
        elements.append(element)
        return true
    }
    
    public mutating func dequeue() -> T? {
        isEmpty ? nil : elements.removeFirst()
    }
    
    public func getElements() -> [T] {
        return elements
    }
}

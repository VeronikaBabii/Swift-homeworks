//
//  Queue.swift
//
//  Created by Veronika Babii on 16.11.2021.
//

import Foundation

public protocol Queue {
    associatedtype Element
    
    var isEmpty: Bool { get }
    var peek: Element? { get }
    
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
}

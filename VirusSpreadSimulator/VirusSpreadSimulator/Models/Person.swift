//
//  Person.swift
//  VirusSpreadSimulator
//

import Foundation

struct Person {
    
    enum Status {
        case healthy
        case infected
    }
    
    var status: Status
    var point: CGPoint
    var canInfect: Bool
    
    static func != (lhs: Person, rhs: Person) -> Bool {
        return lhs.status != rhs.status || lhs.point != rhs.point
    }
    
}

extension Person {
    
    func distance(to otherPerson: Person) -> CGFloat {
        let dx = point.x - otherPerson.point.x
        let dy = point.y - otherPerson.point.y
        return sqrt(dx * dx + dy * dy)
    }
    
}

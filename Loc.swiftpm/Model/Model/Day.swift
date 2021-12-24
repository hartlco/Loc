import Foundation

public protocol DayProtocol {
    var simplifiedDate: Date? { get }
}

struct Day: DayProtocol {
    var simplifiedDate: Date?
}

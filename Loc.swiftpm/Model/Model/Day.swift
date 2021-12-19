import Foundation

public protocol DayProtocol {
    var simplifiedDate: Date? { get }

    func getItems() -> [ItemProtocol]
}

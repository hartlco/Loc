import Foundation
import CoreData

public protocol ItemProtocol {
    var timestamp: Date? { get }
    var longitude: Double { get }
    var latitude: Double { get }

    func getDay() -> DayProtocol?
    func getPlace() -> PlaceProtocol?
}

extension Item: ItemProtocol {
    public func getPlace() -> PlaceProtocol? {
        return place
    }

    public func getDay() -> DayProtocol? {
        return day
    }

    public static func allRequest() -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]

        return request
    }

    public static func allForDayRequest(day: Day) -> NSFetchRequest<Item> {
        let request = Item.allRequest()
        request.predicate = NSPredicate(format: "day == %@", day as CVarArg)

        return request
    }
}

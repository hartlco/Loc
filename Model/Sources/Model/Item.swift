import Foundation
import CoreData

public extension Item {
    static func allRequest() -> NSFetchRequest<Item> {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)]

        return request
    }

    static func allForDayRequest(day: Day) -> NSFetchRequest<Item> {
        let request = Item.allRequest()
        request.predicate = NSPredicate(format: "day == %@", day as CVarArg)

        return request
    }
}

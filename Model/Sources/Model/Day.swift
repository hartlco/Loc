import Foundation
import CoreData

public protocol DayProtocol {
    var simplifiedDate: Date? { get }

    func getItems() -> [Item]
}

extension Day: DayProtocol {
    public func getItems() -> [Item] {
        guard let items = items?.allObjects as? [Item] else {
            return []
        }

        return items.sorted {
            guard let date1 = $0.timestamp,
                  let date2 = $1.timestamp else {
                      return false
                  }

            return date1 > date2
        }
    }

    public static func allRequest() -> NSFetchRequest<Day> {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.simplifiedDate, ascending: false)]

        return request
    }

    public static func fetchRequest(for date: Date) -> NSFetchRequest<Day> {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.predicate = NSPredicate(format: "simplifiedDate == %@", date as CVarArg)

        return request
    }
}

import Foundation
import CoreData

extension Day {
    static func allRequest() -> NSFetchRequest<Day> {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.simplifiedDate, ascending: false)]

        return request
    }

    static func fetchRequest(for date: Date) -> NSFetchRequest<Day> {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.predicate = NSPredicate(format: "simplifiedDate == %@", date as CVarArg)

        return request
    }
}

import Foundation
import CoreData

final class DayStore: NSObject, ObservableObject {
    private let persistenceController: PersistenceController
    private let calendar: Calendar
    private let daysController: NSFetchedResultsController<Day>

    @Published var allDays: [Day] = []

    init(persistenceController: PersistenceController = .shared,
         calendar: Calendar = .current) {
        self.persistenceController = persistenceController
        self.calendar = calendar
        self.daysController = .init(fetchRequest: Day.allRequest(),
                                    managedObjectContext: persistenceController.container.viewContext,
                                    sectionNameKeyPath: nil,
                                    cacheName: nil)

        super.init()

        self.daysController.delegate = self

        do {
            try daysController.performFetch()
            allDays = daysController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch all days")
        }
    }

    func dayForNow() -> Day {
        let now = Date()
        let simplifiedComponents = calendar.dateComponents([.year, .month, .day],
                                                           from: now)
        let simplifiedDate = calendar.date(from: simplifiedComponents)!
        let days = try! persistenceController.container.viewContext.fetch(Day.fetchRequest(for: simplifiedDate))

        if let day = days.first {
            return day
        } else {
            let day = Day(context: self.persistenceController.container.viewContext)
            day.simplifiedDate = simplifiedDate

            return day
        }
    }
}

extension DayStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let allDays = controller.fetchedObjects as? [Day] else { return }

        self.allDays = allDays
    }
}

import Foundation
import CoreData
import OSLog

final class DayStore: NSObject, ObservableObject {
    private let persistenceController: PersistenceController
    private let calendar: Calendar
    private let daysController: NSFetchedResultsController<Day>
    private let itemsController: NSFetchedResultsController<Item>
    private let logger: Logger

    @Published var allDays: [Day] = []
    @Published var allItems: [Item] = []

    init(persistenceController: PersistenceController = .shared,
         calendar: Calendar = .current,
         logger: Logger) {
        self.persistenceController = persistenceController
        self.calendar = calendar
        self.logger = logger
        self.daysController = .init(fetchRequest: Day.allRequest(),
                                    managedObjectContext: persistenceController.container.viewContext,
                                    sectionNameKeyPath: nil,
                                    cacheName: nil)

        self.itemsController = .init(fetchRequest: Item.allRequest(),
                                    managedObjectContext: persistenceController.container.viewContext,
                                    sectionNameKeyPath: nil,
                                    cacheName: nil)

        super.init()

        self.daysController.delegate = self

        do {
            logger.info("Fetching allDays")
            try daysController.performFetch()
            allDays = daysController.fetchedObjects ?? []
        } catch {
            logger.critical("Failed to fetch allDays")
        }

        do {
            logger.info("Fetching allItems")
            try itemsController.performFetch()
            allItems = itemsController.fetchedObjects ?? []
        } catch {
            logger.critical("Failed to fetch allItems")
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

    func itemsStore(for day: Day) -> ItemsForDay {
        ItemsForDay(day: day, logger: logger)
    }
}

extension DayStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let allDays = controller.fetchedObjects as? [Day] {
            self.allDays = allDays
        }

        if let allItems = controller.fetchedObjects as? [Item] {
            self.allItems = allItems
        }
    }
}

import Foundation
import CoreData
import OSLog
import Model

public final class DayStore: NSObject, ObservableObject {
    private let persistenceController: PersistenceController
    private let calendar: Calendar
    private let daysController: NSFetchedResultsController<Day>
    private let itemsController: NSFetchedResultsController<Item>
    private let logger: Logger

    @Published public var allDays: [Day] = []
    @Published public var allItems: [Item] = []

    public init(persistenceController: PersistenceController,
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

    public func dayForNow() -> Day {
        let now = Date()
        let simplifiedComponents = calendar.dateComponents([.year, .month, .day],
                                                           from: now)

        guard let simplifiedDate = calendar.date(from: simplifiedComponents) else {
            logger.critical("simplifiedDate could not be created")
            fatalError()
        }

        do {
            let days = try persistenceController.container.viewContext.fetch(Day.fetchRequest(for: simplifiedDate))

            if let day = days.first {
                return day
            } else {
                let day = Day(context: persistenceController.container.viewContext)
                day.simplifiedDate = simplifiedDate

                return day
            }
        } catch {
            logger.critical("PersistenceController could not fetch day")
            return Day(context: persistenceController.container.viewContext)
        }
    }

    public func itemsStore(for day: Day) -> ItemsForDayStore {
        ItemsForDayStore(persistenceController: persistenceController,
                         day: day,
                         logger: logger)
    }
}

extension DayStore: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let allDays = controller.fetchedObjects as? [Day] {
            self.allDays = allDays
        }

        if let allItems = controller.fetchedObjects as? [Item] {
            self.allItems = allItems
        }
    }
}

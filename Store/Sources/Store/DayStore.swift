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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectsDidChangeHandler(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: persistenceController.container.viewContext)

        self.daysController.delegate = self
        self.itemsController.delegate = self

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

    public func itemStore(for item: Item) -> ItemStore {
        ItemStore(
            persistenceController: persistenceController,
            calendar: calendar,
            dayStore: self,
            logger: logger,
            item: item
        )
    }

    public func items(for day: Day) -> [Item] {
        return allItems.filter { item in
            item.day == day
        }
    }

    @objc private func managedObjectsDidChangeHandler(notification: NSNotification) {
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
}

extension DayStore: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}

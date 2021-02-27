import Foundation
import CoreData
import OSLog

final class ItemsStore: NSObject, ObservableObject {
    private let persistenceController: PersistenceController
    private let itemsController: NSFetchedResultsController<Item>
    private let logger: Logger

    @Published var allItems: [Item] = []

    init(persistenceController: PersistenceController = .shared,
         day: Day,
         logger: Logger) {
        self.persistenceController = persistenceController
        self.itemsController = .init(fetchRequest: Item.allForDayRequest(day: day),
                                     managedObjectContext: persistenceController.container.viewContext,
                                     sectionNameKeyPath: nil,
                                     cacheName: nil)
        self.logger = logger

        super.init()

        self.itemsController.delegate = self

        do {
            logger.info("Fetching allItem for day: \(day)")
            try itemsController.performFetch()
            allItems = itemsController.fetchedObjects ?? []
        } catch {
            logger.critical("Failed to fetch items for day: \(day)")
        }
    }

    func delete(item: Item) {
        do {
            persistenceController.container.viewContext.delete(item)
            try persistenceController.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension ItemsStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let allItems = controller.fetchedObjects as? [Item] else { return }

        self.allItems = allItems
    }
}

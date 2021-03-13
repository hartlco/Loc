import CoreData
import OSLog

public struct PersistenceController {
    struct Constants {
        static let groupName = "group.co.hartl.loc"
        static let persistenceContainerName = "Loc"
    }

    private let logger: Logger
    public let container: NSPersistentContainer

    // swiftlint:disable line_length
    public init(inMemory: Bool = false,
                fileManager: FileManager = .default,
                logger: Logger) {
        guard let modelURL = Bundle.module.url(forResource: Constants.persistenceContainerName,
                                               withExtension: "momd") else {
            fatalError()
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError()
        }

        self.logger = logger
        container = NSPersistentContainer(name: Constants.persistenceContainerName,
                                          managedObjectModel: model)
        guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupName) else {
            logger.critical("ContainerURL for persistence store can not be created")
            fatalError()
        }

        let storeURL = containerURL.appendingPathComponent(Constants.persistenceContainerName + ".sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                logger.critical("Unresolved error \(error), \(error.userInfo)")
                fatalError()
            }
        })
    }
}

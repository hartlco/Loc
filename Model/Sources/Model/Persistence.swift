import CoreData
import OSLog

public struct PersistenceController {
    struct Constants {
        static let groupName = "group.co.hartl.loc"
        static let persistenceContainerName = "Loc"
    }

    public static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // TODO: Add Logging
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    public let container: NSPersistentContainer

    // swiftlint:disable line_length
    init(inMemory: Bool = false,
         fileManager: FileManager = .default) {
        guard let modelURL = Bundle.module.url(forResource: Constants.persistenceContainerName,
                                               withExtension: "momd") else {
            fatalError()
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError()
        }

        container = NSPersistentContainer(name: Constants.persistenceContainerName,
                                          managedObjectModel: model)
        guard let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Constants.groupName) else {
            // TODO: Loggin
            fatalError()
        }

        let storeURL = containerURL.appendingPathComponent(Constants.persistenceContainerName + ".sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // TODO: Add Logging
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

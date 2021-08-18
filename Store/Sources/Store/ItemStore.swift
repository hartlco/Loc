import Foundation
import MapKit
import OSLog
import Model

public final class ItemStore: ObservableObject {
    private let persistenceController: PersistenceController
    private let calendar: Calendar
    private let dayStore: DayStore
    private let logger: Logger
    private var item: Item?

    @Published public var title: String = "" {
        didSet {
            if let item = item, item.note == nil {
                let newNote = Note(context: persistenceController.container.viewContext)
                item.note = newNote
                newNote.item = item
            }

            item?.note?.title = title
        }
    }

    @Published public var body: String = "" {
        didSet {
            if let item = item, item.note == nil {
                let newNote = Note(context: persistenceController.container.viewContext)
                item.note = newNote
                newNote.item = item
            }

            item?.note?.body = body
        }
    }

    public init(persistenceController: PersistenceController,
                calendar: Calendar = .current,
                dayStore: DayStore,
                logger: Logger,
                item: Item? = nil) {
        self.persistenceController = persistenceController
        self.calendar = calendar
        self.dayStore = dayStore
        self.logger = logger
        self.item = item

        self.title = item?.note?.title ?? ""
    }

    public func storeItem(for location: CLLocation, placemarks: [CLPlacemark]) {
        let dayForNow = dayStore.dayForNow()
        let newItem = Item(context: self.persistenceController.container.viewContext)

        if let firstLocation = placemarks.first {
            let place = Place(context: persistenceController.container.viewContext)
            place.name = firstLocation.name
            place.isoCountryCode = firstLocation.isoCountryCode
            place.administrativeArea = firstLocation.administrativeArea
            place.country = firstLocation.country
            newItem.place = place

        }

        newItem.timestamp = Date()
        newItem.latitude = location.coordinate.latitude
        newItem.longitude = location.coordinate.longitude

        dayForNow.addToItems(newItem)

        save()
    }

    public func save() {
        do {
            try self.persistenceController.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            logger.critical("Failed to storeItem: \(nsError) \(nsError.userInfo)")
        }
    }
}

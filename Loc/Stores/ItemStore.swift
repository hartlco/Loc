import Foundation
import MapKit
import OSLog

final class ItemStore {
    private let persistenceController: PersistenceController
    private let calendar: Calendar
    private let dayStore: DayStore
    private let logger: Logger

    init(persistenceController: PersistenceController = .shared,
         calendar: Calendar = .current,
         dayStore: DayStore,
         logger: Logger) {
        self.persistenceController = persistenceController
        self.calendar = calendar
        self.dayStore = dayStore
        self.logger = logger
    }

    func storeItem(for location: CLLocation, placemarks: [CLPlacemark]) {
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

        do {
            try self.persistenceController.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            logger.critical("Failed to storeItem: \(nsError) \(nsError.userInfo)")
        }
    }
}

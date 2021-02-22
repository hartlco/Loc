import Foundation
import MapKit

final class ItemStore {
    let persistenceController: PersistenceController
    let calendar: Calendar
    let dayStore: DayStore

    init(persistenceController: PersistenceController = .shared,
         calendar: Calendar = .current,
         dayStore: DayStore = .init()) {
        self.persistenceController = persistenceController
        self.calendar = calendar
        self.dayStore = dayStore
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
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

import Foundation
import MapKit
import OSLog

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager: CLLocationManager
    private let itemStore: ItemStore
    private let logger: Logger

    init(itemStore: ItemStore,
         logger: Logger) {
        self.manager = CLLocationManager()
        self.itemStore = itemStore
        self.logger = logger

        super.init()

        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.startMonitoringSignificantLocationChanges()
        manager.delegate = self
    }

    func requestToStoreCurrentLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(
                location,
                completionHandler: { placemarks, _ in
                    self.itemStore.storeItem(for: location, placemarks: placemarks ?? [])
                })
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("LocationService didFailWithError: \(error.localizedDescription)")
    }
}

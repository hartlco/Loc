import Foundation
import MapKit

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager: CLLocationManager
    private let itemStore: ItemStore

    init(itemStore: ItemStore) {
        self.manager = CLLocationManager()
        self.itemStore = itemStore

        super.init()

        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.startMonitoringSignificantLocationChanges()
        manager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(
                location,
                completionHandler: { placemarks, error in
                    self.itemStore.storeItem(for: location, placemarks: placemarks ?? [])
                })
        }
    }
}

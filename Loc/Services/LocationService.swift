import Foundation
import MapKit
import OSLog
import Store

final class LocationService: NSObject {
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

    var hasLocationPermission: Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .denied, .notDetermined, .restricted:
                return false
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }

    func requestToStoreCurrentLocation() {
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
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

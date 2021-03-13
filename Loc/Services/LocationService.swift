import Foundation
import MapKit
import OSLog
import Store
import WidgetKit

final class LocationService: NSObject {
    private let manager: CLLocationManager
    private let itemStore: ItemStore
    private let logger: Logger
    private let widgetCenter: WidgetCenter

    init(itemStore: ItemStore,
         logger: Logger,
         widgetCenter: WidgetCenter = .shared) {
        self.manager = CLLocationManager()
        self.itemStore = itemStore
        self.logger = logger
        self.widgetCenter = widgetCenter

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
                completionHandler: { [weak self] placemarks, _ in
                    guard let self = self else { return }

                    self.itemStore.storeItem(for: location, placemarks: placemarks ?? [])
                    self.widgetCenter.reloadAllTimelines()
                })
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("LocationService didFailWithError: \(error.localizedDescription)")
    }
}

import MapKit

// https://gist.github.com/robmooney/923301#gistcomment-2765115
extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0

        for coordinate in coordinates {
            let lat = Double(coordinate.latitude)
            let long = Double(coordinate.longitude)
            if lat < minLat {
                minLat = lat
            }
            if long < minLon {
                minLon = long
            }
            if lat > maxLat {
                maxLat = lat
            }
            if long > maxLon {
                maxLon = long
            }
        }

        let latDelta = max((maxLat - minLat)*2.0, 0.005)
        let lonDelta = max((maxLon - minLon)*2.0, 0.005)

        let span = MKCoordinateSpan(latitudeDelta: latDelta,
                                    longitudeDelta: lonDelta)
        let center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 4, maxLon - span.longitudeDelta / 4)
        self.init(center: center, span: span)
    }
}

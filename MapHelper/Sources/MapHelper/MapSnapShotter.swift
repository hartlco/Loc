import MapKit

public struct MapSnapShotter {
    private let region: MKCoordinateRegion
    private let coordinates: [CLLocationCoordinate2D]
    private let size: CGSize

    public init(region: MKCoordinateRegion,
                coordinates: [CLLocationCoordinate2D],
                size: CGSize) {
        self.region = region
        self.coordinates = coordinates
        self.size = size
    }

    public func snapshot(completion: @escaping (UIImage?, Error?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(coordinates: coordinates)
        options.size = size

        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start { snapshot, error in

            guard let snapshot = snapshot else {
                completion(nil, error)
                return
            }

            // https://stackoverflow.com/a/42773351
            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                snapshot.image.draw(at: .zero)

                for coordinate in coordinates {
                    let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                    let pinImage = pinView.image

                    var point = snapshot.point(for: coordinate)
                    point.x -= pinView.bounds.width / 2
                    point.y -= pinView.bounds.height / 2
                    point.x += pinView.centerOffset.x
                    point.y += pinView.centerOffset.y
                    pinImage?.draw(at: point)
                }
            }

            DispatchQueue.main.async {
                completion(image, nil)
            }
        }
    }
}

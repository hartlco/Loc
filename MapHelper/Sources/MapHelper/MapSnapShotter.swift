import MapKit
import Combine

public class MapSnapShotter {
    public struct Snapshot {
        public let light: UIImage
        public let dark: UIImage
    }

    private let region: MKCoordinateRegion
    private let coordinates: [CLLocationCoordinate2D]
    private let size: CGSize

    private var cancellable: AnyCancellable?

    public init(region: MKCoordinateRegion,
                coordinates: [CLLocationCoordinate2D],
                size: CGSize) {
        self.region = region
        self.coordinates = coordinates
        self.size = size
    }

    public func snapshot(completion: @escaping (Snapshot) -> Void) {
        let lightOptions = MKMapSnapshotter.Options()
        lightOptions.region = MKCoordinateRegion(coordinates: coordinates)
        lightOptions.size = size
        lightOptions.traitCollection = UITraitCollection(userInterfaceStyle: .light)

        let darkOptions = MKMapSnapshotter.Options()
        darkOptions.region = MKCoordinateRegion(coordinates: coordinates)
        darkOptions.size = size
        darkOptions.traitCollection = UITraitCollection(userInterfaceStyle: .dark)

        cancellable = snapshot(using: lightOptions)
            .merge(with: snapshot(using: darkOptions))
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { images in
                guard let light = images.first,
                      let dark = images.last else { return }

                completion(.init(light: light, dark: dark))
            }
    }

    private func snapshot(using options: MKMapSnapshotter.Options) -> Future<UIImage, Never> {
        Future { promise in
            let snapShotter = MKMapSnapshotter(options: options)
            snapShotter.start { snapshot, _ in
                guard let snapshot = snapshot else {
                    return
                }

                // https://stackoverflow.com/a/42773351
                let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                    snapshot.image.draw(at: .zero)

                    for coordinate in self.coordinates {
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

                promise(.success(image))
            }
        }
    }
}

public extension MapSnapShotter.Snapshot {
    static func fromImagesNamed(light: String, dark: String) -> Self? {
        guard let light = UIImage(named: light),
              let dark = UIImage(named: dark) else {
            return nil
        }

        return MapSnapShotter.Snapshot(light: light, dark: dark)
    }
}

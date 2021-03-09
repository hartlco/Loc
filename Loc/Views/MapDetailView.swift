import SwiftUI
import MapKit
import Model

struct MapDetailView: View {
    @State private var region: MKCoordinateRegion
    private let item: Item

    init(item: Item) {
        let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span )
        self._region = State<MKCoordinateRegion>(initialValue: region)

        self.item = item
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [item]) { item in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: item.latitude,
                                                      longitude: item.longitude))
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

import SwiftUI
import MapKit

struct MapDetailView: View {
    @State private var region: MKCoordinateRegion
    private let item: Item

    init(item: Item) {
        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
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

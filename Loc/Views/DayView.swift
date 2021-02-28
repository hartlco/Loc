import SwiftUI
import CoreData
import MapKit

struct DayView: View {
    let itemsStore: ItemsForDay

    @State private var region: MKCoordinateRegion

    init(itemsStore: ItemsForDay) {
        self.itemsStore = itemsStore

        let allItems = itemsStore.allItems
        let locations = allItems.map {
            CLLocationCoordinate2D(latitude: $0.latitude,
                                   longitude: $0.longitude)
        }

        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(coordinates: locations))
    }

    var body: some View {
        List {
            Map(coordinateRegion: $region, annotationItems: itemsStore.allItems) { item in
                MapPin(coordinate: CLLocationCoordinate2D(latitude: item.latitude,
                                                          longitude: item.longitude))
            }
            .frame(height: 220)
            ForEach(itemsStore.allItems) { item in
                NavigationLink(
                    destination: MapDetailView(item: item)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(item.place?.name ?? "")")
                            Text("\(item.place?.administrativeArea ?? "")")
                        }
                        Text("\(item.timestamp ?? Date(), formatter: Self.dateFormatter)")
                            .font(.caption)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Locations")
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { self.itemsStore.allItems[$0] }.forEach {
                itemsStore.delete(item: $0)
            }
        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
}

import SwiftUI
import CoreData
import MapKit

struct DayView: View {
    let day: Day

    var itemsRequest: FetchRequest<Item>
    var items: FetchedResults<Item> { itemsRequest.wrappedValue }

    @State private var region: MKCoordinateRegion

    @Environment(\.managedObjectContext) private var viewContext

    init(day: Day) {
        self.day = day
        self.itemsRequest = FetchRequest(entity: Item.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
                                         predicate: NSPredicate(format: "day == %@", day as CVarArg))

        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(coordinates: []))

        let allItems = day.items?.compactMap {
            $0 as? Item
        } ?? []

        let locations = allItems.map {
            CLLocationCoordinate2D(latitude: $0.latitude,
                                   longitude: $0.longitude)
        }

        self._region = State<MKCoordinateRegion>(initialValue: MKCoordinateRegion(coordinates: locations))
    }

    var body: some View {
        List {
            Map(coordinateRegion: $region, annotationItems: items) { item in
                MapPin(coordinate: CLLocationCoordinate2D(latitude: item.latitude,
                                                          longitude: item.longitude))
            }
            .frame(height: 220)
            ForEach(items) { item in
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
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

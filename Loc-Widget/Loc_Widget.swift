import WidgetKit
import SwiftUI
import Model
import Store
import OSLog
import MapKit
import MapHelper

class Provider: TimelineProvider {
    let store: DayStore
    var snapShotter: MapSnapShotter?

    init(store: DayStore) {
        self.store = store
    }

    func placeholder(in context: Context) -> SimpleEntry {
        let item = PlaceholderLocationItem(placeName: "California", date: Date())
        return SimpleEntry(date: Date(),
                           item: item,
                           image: .fromImagesNamed(light: "placeholder-map-dark", dark: "placeholder-map-light"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        guard let first = store.allItems.first else {
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: first.latitude,
                                                longitude: first.longitude)
        let region = MKCoordinateRegion(coordinates: [coordinate])
        self.snapShotter = MapSnapShotter(region: region,
                                         coordinates: [coordinate],
                                         size: CGSize(width: 400, height: 400))

        snapShotter?.snapshot { image in
            let entry = SimpleEntry(date: first.timestamp ?? Date(),
                                    item: first,
                                    image: image)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        guard let first = store.allItems.first else {
            completion(Timeline(entries: [], policy: .atEnd))
            return
        }

        let coordinate = CLLocationCoordinate2D(latitude: first.latitude,
                                                longitude: first.longitude)
        let region = MKCoordinateRegion(coordinates: [coordinate])
        self.snapShotter = MapSnapShotter(region: region,
                                         coordinates: [coordinate],
                                         size: CGSize(width: 400, height: 400))

        snapShotter?.snapshot { image in
            let entry = SimpleEntry(date: first.timestamp ?? Date(),
                                    item: first,
                                    image: image)
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let item: WidgetLocationItem?
    let image: MapSnapShotter.Snapshot?
}

struct LocWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            if let image = entry.image, let item = entry.item {
                if colorScheme == .light {
                    Image(uiImage: image.light)
                        .resizable()
                } else {
                    Image(uiImage: image.dark)
                        .resizable()
                }
                VStack {
                    Spacer()
                    Text(item.placeName ?? "")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Text("\(item.date ?? Date(), formatter: Self.dateFormatter)")
                        .font(.caption2)
                }
            } else {
                EmptyItemView()
            }
        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct EmptyItemView: View {
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "placeholder-map-light")!)
                .resizable()
        }
    }
}

@main
struct LocWidget: Widget {
    let kind: String = "Loc_Widget"
    let logger = Logger(subsystem: "co.hartl.Loc",
                        category: "Widget")
    let store: DayStore

    init() {
        self.store = DayStore(persistenceController: PersistenceController(logger: logger),
                              logger: logger)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(store: store)) { entry in
            LocWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

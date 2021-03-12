import WidgetKit
import SwiftUI
import Model
import Store
import OSLog
import MapKit
import MapHelper

struct Provider: TimelineProvider {
    let store: DayStore

    init(store: DayStore) {
        self.store = store
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), item: nil, image: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), item: nil, image: nil)
        completion(entry)
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
        let snapShotter = MapSnapShotter(region: region,
                                         coordinates: [coordinate],
                                         size: CGSize(width: 400, height: 400))

        snapShotter.snapshot { image, _ in
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
    let item: Item?
    let image: UIImage?
}

struct LocWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            if let image = entry.image {
                Image(uiImage: image)
                    .resizable()
            }
            Text(entry.item?.place?.country ?? "")
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
        self.store = DayStore(logger: logger)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(store: store)) { entry in
            LocWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

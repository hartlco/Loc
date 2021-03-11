import WidgetKit
import SwiftUI
import Model
import Store
import OSLog

struct Provider: TimelineProvider {
    let store: DayStore

    init(store: DayStore) {
        self.store = store
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), item: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), item: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        let first = store.allItems.first

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,
                                    item: first)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let item: Item?
}

struct LocWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.item?.place?.country ?? "")
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

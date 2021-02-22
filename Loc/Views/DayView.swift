import SwiftUI
import CoreData

struct DayView: View {
    let day: Day

    var itemsRequest: FetchRequest<Item>
    var items: FetchedResults<Item> { itemsRequest.wrappedValue }

    @Environment(\.managedObjectContext) private var viewContext

    init(day: Day) {
        self.day = day
        self.itemsRequest = FetchRequest(entity: Item.entity(),
                                         sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
                                         predicate: NSPredicate(format: "day == %@", day as CVarArg))
    }

    var body: some View {
        List {
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

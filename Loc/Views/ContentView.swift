import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.simplifiedDate, ascending: false)],
        animation: .default)
    private var days: FetchedResults<Day>

    var body: some View {
        List {
            ForEach(days) { day in
                NavigationLink(
                    destination: DayView(day: day)) {
                    Text("\(day.simplifiedDate ?? Date(), formatter: Self.dayDateFormatter)")
                }
            }
        }
        .navigationTitle("Days")
    }

    static let dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    let dayStore: DayStore

    var body: some View {
        List {
            ForEach(dayStore.allDays) { day in
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

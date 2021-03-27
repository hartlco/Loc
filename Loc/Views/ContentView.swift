import SwiftUI
import CoreData
import MapKit
import Store
import Model

struct ContentView: View {
    let dayStore: DayStore
    let locationService: LocationService

    var body: some View {
        List {
            if !locationService.hasLocationPermission {
                Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }, label: {
                    Label(
                        title: { Text("Location Service disabled") },
                        icon: { Image(systemName: "exclamationmark.triangle.fill") }
                    )
                })
            }
            ForEach(dayStore.allDays) { day in
                NavigationLink(
                    destination: DayView(itemsStore: dayStore.itemsStore(for: day))) {
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

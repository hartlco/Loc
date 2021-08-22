import SwiftUI
import CoreData
import MapKit
import Store
import Model

struct ContentView: View {
    @ObservedObject var dayStore: DayStore
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
                Section {
                    ForEach(day.getItems()) { item in
                        NavigationLink(
                            destination: ItemDetailView(itemStore: dayStore.itemStore(for: item))) {
                                VStack(alignment: .leading) {
                                    Text(item.note?.title ?? "")
                                        .font(.headline)
                                    Text(item.note?.body ?? "")
                                        .font(.body)
                                    HStack {
                                        Text("\(item.place?.name ?? "")")
                                        Text("\(item.place?.administrativeArea ?? "")")
                                    }
                                    Text(item.timestamp?.formatted(date: .omitted, time: .standard) ?? "")
                                        .font(.caption)
                                }
                            }
                    }
                } header: {
                    Text(day.simplifiedDate?.formatted(date: .long, time: .omitted) ?? "")
                }
            }
        }
        .navigationTitle("Days")
    }
}

struct ItemDetailView: View {
    @ObservedObject var itemStore: ItemStore

    var body: some View {
        VStack {
            TextField("Title", text: $itemStore.title)
                .onSubmit {
                    itemStore.save()
                }
            TextEditor(text: $itemStore.body)
                .onSubmit {
                    itemStore.save()
                }
        }
    }
}

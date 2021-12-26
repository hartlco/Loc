import SwiftUI
import MapKit
import Photos

struct ContentView: View {
    @ObservedObject var dayStore: DayStore
    @ObservedObject var timelineStore: TimelineStore

    let locationService: LocationService

    var body: some View {
        List {
            if !locationService.hasLocationPermission {
                Button(action: {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!
                    )
                }, label: {
                    Label(
                        title: { Text("Location Service disabled") },
                        icon: { Image(systemName: "exclamationmark.triangle.fill"
                        ) 
                        }
                    )
                })
            }
            ForEach(timelineStore.allDays) { (day: TimelineStore.Day) in
                Section {
                    ForEach(day.entries) { (entry: TimelineStore.Entry) in
                        switch entry {
                        case .entry(let item):
                            NavigationLink(
                                destination: ItemDetailView(itemStore: dayStore.itemStore(for: item))
                            ) {
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
                        case .photoSuggestion(let result):
                            Text("Photo Suggestion")
                            ScrollView([.horizontal]) {
                                HStack {
                                    ForEach(0..<result.count) { index in
                                        Image(uiImage: result[index].image)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text(
                        day.simplifiedDate.formatted(date: .long, time: .omitted) ?? ""
                    )
                }
            }
        }
        .toolbar{ 
            Button("Add") { 
                
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

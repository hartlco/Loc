import SwiftUI
import Store

struct SettingsView: View {
    let dayStore: DayStore
    let exportService: ExportService

    @State private var showAllJSONExport = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Export")) {
                    Button {
                        showAllJSONExport = true
                    } label: {
                        Label("Export all in JSON", systemImage: "square.and.arrow.up")
                            .foregroundColor(.primary)
                    }
                }
            }
            .fileMover(isPresented: $showAllJSONExport,
                       file: exportService.exportAllItemsToTemporaryPath()) { _ in
            }
            .navigationTitle("Settings")
        }
    }
}

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Export")) {
                    Button {

                    } label: {
                        Label("Export all in JSON", systemImage: "square.and.arrow.up")
                            .foregroundColor(.primary)
                    }
                    NavigationLink(destination: Text("hi")) {
                        Label("Export days in JSON", systemImage: "calendar")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

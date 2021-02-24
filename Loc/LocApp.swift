import SwiftUI
import CoreLocation
import CoreData

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        return true
    }
}

@main
struct LocApp: App {
    let persistenceController = PersistenceController.shared
    let locationManager = LocationService()

    @StateObject var dayStore: DayStore
    @State private var showsSettings = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        let dayStore = DayStore()
        self._dayStore = StateObject(wrappedValue: dayStore)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(dayStore: dayStore)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        showsSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                    .sheet(isPresented: $showsSettings) {
                        SettingsView()
                    }
                    Spacer()
                    Button {

                    } label: {
                        Label("Log now", systemImage: "mappin.circle")
                    }
                }
            }
            
        }
    }
}

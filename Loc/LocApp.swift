import SwiftUI
import CoreLocation
import CoreData
import OSLog

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@main
struct LocApp: App {
    let persistenceController = PersistenceController.shared
    let locationManager: LocationService
    let logger = Logger(subsystem: "co.hartl.Loc", category: "Main-App")

    @StateObject var dayStore: DayStore
    @State private var showsSettings = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        let dayStore = DayStore(logger: logger)
        self._dayStore = StateObject(wrappedValue: dayStore)
        self.locationManager = LocationService(itemStore: ItemStore(dayStore: dayStore,
                                                                    logger: logger))
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
                        SettingsView(dayStore: dayStore,
                                     exportService: ExportService(dayStore: dayStore))
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

import SwiftUI
import CoreLocation
import CoreData
import OSLog
import Model
import Store

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
}

@main
struct LocApp: App {
    let persistenceController: PersistenceController
    let locationManager: LocationService
    let logger = Logger(subsystem: "co.hartl.Loc", category: "Main-App")
    let photoService = PhotoService()

    @StateObject var dayStore: DayStore
    @State private var showsSettings = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        self.persistenceController = PersistenceController(logger: logger)

        let dayStore = DayStore(persistenceController: persistenceController, logger: logger)
        self._dayStore = StateObject(wrappedValue: dayStore)

        self.locationManager = LocationService(itemStore: ItemStore(persistenceController: persistenceController,
                                                                    dayStore: dayStore,
                                                                    logger: logger),
                                               logger: logger)

        photoService.requestAccess()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(dayStore: dayStore, locationService: locationManager)
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
                        locationManager.requestToStoreCurrentLocation()
                    } label: {
                        Label("Log now", systemImage: "mappin.circle")
                    }
                }
            }
        }
    }
}

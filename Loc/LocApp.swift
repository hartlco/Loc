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

    @State private var showsSettings = false

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
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
                        Text("hi")
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

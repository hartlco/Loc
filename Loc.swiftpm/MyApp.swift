import SwiftUI
import OSLog

@main
struct MyApp: App {
    let dayStore = DayStore(logger: Self.logger)

    var body: some Scene {
        WindowGroup {
            ContentView(
                dayStore: dayStore,
                timelineStore: TimelineStore(dayStore: dayStore),
                locationService: locationService)
        }
    }

    var locationService: LocationService {
        LocationService(
            itemStore: .init(dayStore: dayStore, logger: Self.logger),
            logger: Self.logger
        )
    }

    static let logger = Logger()
}

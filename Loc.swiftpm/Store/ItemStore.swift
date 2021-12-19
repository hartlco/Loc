import Foundation
import MapKit
import OSLog

public final class ItemStore: ObservableObject {
    private let calendar: Calendar
    private let dayStore: DayStore
    private let logger: Logger
    private var item: ItemProtocol?

    @Published public var title: String = "" {
        didSet {
            item?.note?.title = title
        }
    }

    @Published public var body: String = "" {
        didSet {
            item?.note?.body = body
        }
    }

    public init(calendar: Calendar = .current,
                dayStore: DayStore,
                logger: Logger,
                item: ItemProtocol? = nil) {
        self.calendar = calendar
        self.dayStore = dayStore
        self.logger = logger
        self.item = item

        self.title = item?.note?.title ?? ""
    }

    public func storeItem(for location: CLLocation, placemarks: [CLPlacemark]) {
//        let dayForNow = dayStore.dayForNow()
//        let newItem = Item(context: self.persistenceController.container.viewContext)
    }

    public func save() {
    }
}

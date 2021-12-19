import Foundation
import OSLog

public final class DayStore: NSObject, ObservableObject {
    private let calendar: Calendar
    private let logger: Logger

    @Published public var allDays: [DayProtocol] = []
    @Published public var allItems: [ItemProtocol] = []

    public init(calendar: Calendar = .current,
                logger: Logger) {
        self.calendar = calendar
        self.logger = logger

        super.init()
    }

    public func dayForNow() -> DayProtocol {
        let now = Date()
        let simplifiedComponents = calendar.dateComponents([.year, .month, .day],
                                                           from: now)

        guard let simplifiedDate = calendar.date(from: simplifiedComponents) else {
            logger.critical("simplifiedDate could not be created")
            fatalError()
        }

        fatalError()
    }

    public func itemsStore(for day: DayProtocol) -> ItemsForDayStore {
        ItemsForDayStore(day: day,
                         logger: logger)
    }

    public func itemStore(for item: ItemProtocol) -> ItemStore {
        ItemStore(
            calendar: calendar,
            dayStore: self,
            logger: logger,
            item: item
        )
    }

    public func items(for day: DayProtocol) -> [ItemProtocol] {
        return allItems.filter { item in
            item.day?.simplifiedDate == day.simplifiedDate
        }
    }
}

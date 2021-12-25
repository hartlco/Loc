import Foundation
import OSLog

public final class DayStore: NSObject, ObservableObject {
    private let calendar: Calendar
    private let logger: Logger
    
    private let userDefaults: UserDefaults

    @Published public var allDays: [Day] = []
    @Published public var allItems: [Item] {
        didSet {
            userDefaults.allItems = allItems
        }
    }

    public init(
        calendar: Calendar = .current,
        userDefautls: UserDefaults = .standard,
        logger: Logger
    ) {
        self.calendar = calendar
        self.userDefaults = userDefautls
        self.logger = logger
        self.allItems = userDefautls.allItems
        
        super.init()
    }

    public func dayForNow() -> Day {
        let now = Date()
        let simplifiedComponents = calendar.dateComponents([.year, .month, .day],
                                                           from: now)

        guard let simplifiedDate = calendar.date(from: simplifiedComponents) else {
            logger.critical("simplifiedDate could not be created")
            fatalError()
        }

        fatalError()
    }

    public func itemsStore(for day: Day) -> ItemsForDayStore {
        ItemsForDayStore(day: day,
                         logger: logger)
    }

    public func itemStore(for item: Item) -> ItemStore {
        ItemStore(
            calendar: calendar,
            dayStore: self,
            logger: logger,
            item: item
        )
    }

    public func items(for day: Day) -> [Item] {
        return allItems.filter { item in
            item.day?.simplifiedDate == day.simplifiedDate
        }
    }
}

extension UserDefaults {
    var allDays: [Day] {
        get {    
            guard let days = value(forKey: #function) as? [Day] else {
                return []
            }
            return days
        }
        set {
            setValue(newValue, forKey: #function)
        }
    }
    
    var allItems: [Item] {
        get {    
            guard let items = value(forKey: #function) as? [Item] else {
                return []
            }
            return items
        }
        set {
            setValue(newValue, forKey: #function)
        }
    }
}

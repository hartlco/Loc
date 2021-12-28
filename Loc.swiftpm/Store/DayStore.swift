import Foundation
import OSLog

public final class DayStore: NSObject, ObservableObject {
    private let calendar: Calendar
    private let logger: Logger
    
    private let userDefaults: UserDefaults

    @Published public var allDays: [Day] {
        didSet {
            userDefaults.allDays = allDays
        }
    }
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
        self.allDays = userDefautls.allDays
        
        super.init()
        
        print("Number of items: \(allItems.count)")
        print("Number of days: \(allDays.count)")
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
    
    public func insertItem() {
        print("Number of items: \(allItems.count)")
        print("Number of days: \(allDays.count)")
        
        let date = Date()
        let day = Day(simplifiedDate: date)
        let note = Note(title: "Test", body: "insert")
        
        let item = Item(
            timestamp: Date(), 
            longitude: 0.0, 
            latitude: 0.0, 
            note: note, 
            day: day, 
            place: nil, 
            id: UUID().uuidString
        )
        
        allItems.append(item)
        allDays.append(day)
        
        print("Number of items: \(allItems.count)")
        print("Number of days: \(allDays.count)")
    }
}

extension UserDefaults {
    var allDays: [Day] {
        get {    
            guard let data = data(forKey: #function),
                  let items = try? JSONDecoder().decode([Day].self, from: data) else { 
                      return []
                  }
            return items
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            set(data, forKey: #function)
        }
    }
    
    var allItems: [Item] {
        get {
            guard let data = data(forKey: #function),
                  let items = try? JSONDecoder().decode([Item].self, from: data) else { 
                      return []
                  }
            return items
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            
            set(data, forKey: #function)
        }
    }
}

import Foundation
import OSLog

public final class ItemsForDayStore: NSObject, ObservableObject {
    private let logger: Logger
    private let day: Day

    @Published public var allItems: [Item] = []

    public init(day: Day,
                logger: Logger) {
        self.logger = logger
        self.day = day

        super.init()
    }

    public func load() {

    }

    public func delete(item: Item) {
    }
}

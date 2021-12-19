import Foundation
import OSLog

public final class ItemsForDayStore: NSObject, ObservableObject {
    private let logger: Logger
    private let day: DayProtocol

    @Published public var allItems: [ItemProtocol] = []

    public init(day: DayProtocol,
                logger: Logger) {
        self.logger = logger
        self.day = day

        super.init()
    }

    public func load() {

    }

    public func delete(item: ItemProtocol) {
    }
}

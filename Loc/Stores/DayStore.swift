import Foundation

final class DayStore {
    let persistenceController: PersistenceController
    let calendar: Calendar

    init(persistenceController: PersistenceController = .shared,
         calendar: Calendar = .current) {
        self.persistenceController = persistenceController
        self.calendar = calendar
    }

    func dayForNow() -> Day {
        let now = Date()
        let simplifiedComponents = calendar.dateComponents([.year, .month, .day],
                                                           from: now)
        let simplifiedDate = calendar.date(from: simplifiedComponents)!
        let days = try! persistenceController.container.viewContext.fetch(Day.fetchRequest(for: simplifiedDate))

        if let day = days.first {
            return day
        } else {
            let day = Day(context: self.persistenceController.container.viewContext)
            day.simplifiedDate = simplifiedDate

            return day
        }
    }
}

import Foundation
import UIKit
import Combine
import PhotosUI

final class TimelineStore: ObservableObject {
    struct Day: Identifiable {
        // swiftlint:disable identifier_name
        var id: String {
            return simplifiedDate.ISO8601Format()
        }

        let simplifiedDate: Date

        var entries: [Entry]
    }

    enum Entry: Identifiable {
        var id: UUID {
            switch self {
            case .entry(let item):
                return UUID()
            case .photoSuggestion(let result):
                return UUID()
            }
        }

        case entry(Item)
        case photoSuggestion([PHAsset])
    }

    private let dayStore: DayStore
    private let photoService: PhotoService = .init()

    private var cancellable: AnyCancellable?

    init(dayStore: DayStore) {
        self.dayStore = dayStore
        self.cancellable = nil

        self.cancellable = dayStore
            .$allDays
            .sink(receiveValue: { [weak self] days in
                guard let self = self else {
                    return
                }

                // TODO: OMG fix
                let photos = self.photoService.photos(from: Date(),
                                                      back: 30)

                var dict = [Date: [Entry]]()

                for index in 0..<photos.count {
                    let photo = photos[index]
                    var entries = dict[photo.creationDate!.simplifiedDate()] ?? []

                    entries.append(.photoSuggestion([photo]))

                    dict[photo.creationDate!.simplifiedDate()] = entries
                }

                let mappedEntries: [TimelineStore.Day] = days.map { day in
                    var entries = [Entry]()

                    let items = self.dayStore.items(for: day)
                    entries += items.map {
                        return Entry.entry($0)
                    }

                    return TimelineStore.Day(simplifiedDate: day.simplifiedDate ?? Date(),
                                             entries: entries)
                }

                for entry in mappedEntries {
                    var entries = dict[entry.simplifiedDate] ?? []
                    entries.append(contentsOf: entry.entries)

                    dict[entry.simplifiedDate] = entries
                }

                self.allDays = dict.map { key, value in
                    TimelineStore.Day(simplifiedDate: key,
                                      entries: value)
                }
            })
    }

    @Published var allDays: [TimelineStore.Day] = []
}

extension Date {
    func simplifiedDate(using calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month, .day],
                                                 from: self)
        return calendar.date(from: components) ?? self
    }
}

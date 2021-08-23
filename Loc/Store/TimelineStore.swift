import Foundation
import Model
import UIKit

final class TimelineStore {
    struct Day {
        let simplifiedDate: Date
        let entries: [Entry]
    }

    enum Entry {
        case entry(Item)
        case photoSuggestion(UIImage)
    }
}

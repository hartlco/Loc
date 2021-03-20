import Foundation
import Model

protocol WidgetLocationItem {
    var placeName: String? { get }
    var date: Date? { get }
}

struct PlaceholderLocationItem: WidgetLocationItem {
    let placeName: String?
    let date: Date?
}

extension Item: WidgetLocationItem {
    var placeName: String? {
        return place?.name ?? place?.administrativeArea
    }

    var date: Date? {
        return timestamp
    }
}

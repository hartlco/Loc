import Foundation
import Model

struct MockPlace: PlaceProtocol {
    let name: String?
    let isoCountryCode: String?
    let country: String?
    let administrativeArea: String?
}

struct MockDay: DayProtocol {
    var simplifiedDate: Date?
}

struct MockItem: ItemProtocol {
    let timestamp: Date?
    let longitude: Double
    let latitude: Double
    let day: MockDay?
    let place: MockPlace?

    func getDay() -> DayProtocol? {
        return day
    }

    func getPlace() -> PlaceProtocol? {
        return place
    }
}

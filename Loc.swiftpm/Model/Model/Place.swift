import Foundation

public protocol PlaceProtocol {
    var name: String? { get }
    var isoCountryCode: String? { get }
    var country: String? { get }
    var administrativeArea: String? { get }
}

struct Place: PlaceProtocol {
    var name: String?
    var isoCountryCode: String?
    var country: String?
    var administrativeArea: String?
}

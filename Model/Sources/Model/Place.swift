import Foundation

public protocol PlaceProtocol {
    var name: String? { get }
    var isoCountryCode: String? { get }
    var country: String? { get }
    var administrativeArea: String? { get }
}

extension Place: PlaceProtocol { }

import Foundation

public protocol ItemProtocol {
    var timestamp: Date? { get }
    var longitude: Double { get }
    var latitude: Double { get }

    var note: NoteProtocol? { get set }
    var day: DayProtocol? { get set }
    var place: PlaceProtocol? { get set }
    var id: ObjectIdentifier { get }
}

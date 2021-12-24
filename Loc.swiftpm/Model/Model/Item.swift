import Foundation

public protocol ItemProtocol {
    var timestamp: Date? { get }
    var longitude: Double { get }
    var latitude: Double { get }

    var note: NoteProtocol? { get set }
    var day: DayProtocol? { get set }    
    var place: PlaceProtocol? { get set } 
    var id: String { get }
}

struct Item: ItemProtocol {
    var timestamp: Date?
    var longitude: Double
    var latitude: Double
    
    var note: NoteProtocol?
    var day: DayProtocol?
    var place: PlaceProtocol?
    
    var id: String
}

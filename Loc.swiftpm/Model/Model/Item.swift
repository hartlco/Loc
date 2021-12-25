import Foundation

public struct Item: Codable {
    var timestamp: Date?
    var longitude: Double
    var latitude: Double
    
    var note: Note?
    var day: Day?
    var place: Place?
    
    var id: String
}

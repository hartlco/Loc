import CoreData

public protocol NoteProtocol {
    var title: String? { get }
    var body: String? { get }
}

extension Note: NoteProtocol { }

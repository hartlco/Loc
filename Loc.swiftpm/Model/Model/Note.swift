public protocol NoteProtocol {
    var title: String? { get set }
    var body: String? { get set }
}

struct Note: NoteProtocol {
    var title: String?
    var body: String?
}

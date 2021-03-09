import Foundation
import Model

final class ExportService {
    private let dayStore: DayStore
    private let fileManager: FileManager

    init(dayStore: DayStore,
         fileManager: FileManager = .default) {
        self.dayStore = dayStore
        self.fileManager = fileManager
    }

    func exportAllItemsToTemporaryPath() -> URL? {
        let items = dayStore.allItems
        let exportModel = ExportModel(items: items)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let jsonData = try? encoder.encode(exportModel) else {
            return nil
        }

        let dateString = ISO8601DateFormatter().string(from: Date())
        let temporaryDirectory = fileManager.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent("Loc-\(dateString).json")

        let jsonString = String(data: jsonData, encoding: .utf8)

        try? jsonString?.write(to: fileURL, atomically: true, encoding: .utf8)

        return fileURL
    }
}

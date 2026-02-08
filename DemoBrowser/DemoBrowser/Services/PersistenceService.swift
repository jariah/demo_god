import Foundation

struct PersistenceService {
    private static let fileName = "demos.json"

    private static var directoryURL: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("DemoBrowser", isDirectory: true)
    }

    private static var fileURL: URL {
        directoryURL.appendingPathComponent(fileName)
    }

    static func load() -> DemoBrowserDocument? {
        let url = fileURL
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let doc = try JSONDecoder().decode(DemoBrowserDocument.self, from: data)
            return doc
        } catch {
            print("[PersistenceService] Failed to load: \(error)")
            return nil
        }
    }

    static func save(_ document: DemoBrowserDocument) {
        do {
            let dir = directoryURL
            if !FileManager.default.fileExists(atPath: dir.path) {
                try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            }
            let data = try JSONEncoder().encode(document)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("[PersistenceService] Failed to save: \(error)")
        }
    }
}

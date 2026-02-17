import Foundation

struct Demo: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var url: String
    var notes: String
    var createdAt: Date
    var isMobileView: Bool

    init(id: UUID = UUID(), name: String, url: String, notes: String = "", createdAt: Date = Date(), isMobileView: Bool = false) {
        self.id = id
        self.name = name
        self.url = url
        self.notes = notes
        self.createdAt = createdAt
        self.isMobileView = isMobileView
    }
}

struct DemoBrowserDocument: Codable {
    var demos: [Demo]
    var activeDemoID: UUID?
    var isNotesPanelVisible: Bool

    init(demos: [Demo] = [], activeDemoID: UUID? = nil, isNotesPanelVisible: Bool = false) {
        self.demos = demos
        self.activeDemoID = activeDemoID
        self.isNotesPanelVisible = isNotesPanelVisible
    }
}

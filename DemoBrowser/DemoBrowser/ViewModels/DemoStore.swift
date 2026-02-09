import Foundation
import Combine

@Observable
final class DemoStore {
    var demos: [Demo] = []
    var activeDemoID: UUID?
    var isNotesPanelVisible: Bool = false
    var isChromeVisible: Bool = true
    var sessionEpoch: Int = 0
    var currentDisplayURL: String = ""
    var editingDemoID: UUID?

    private let saveSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    var activeDemo: Demo? {
        get {
            guard let id = activeDemoID else { return nil }
            return demos.first { $0.id == id }
        }
        set {
            guard let newValue, let idx = demos.firstIndex(where: { $0.id == newValue.id }) else { return }
            demos[idx] = newValue
        }
    }

    init() {
        setupAutoSave()
        loadFromDisk()
    }

    private func setupAutoSave() {
        saveSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] in self?.saveToDisk() }
            .store(in: &cancellables)
    }

    private func loadFromDisk() {
        if let doc = PersistenceService.load(), !doc.demos.isEmpty {
            demos = doc.demos
            activeDemoID = doc.activeDemoID
            isNotesPanelVisible = doc.isNotesPanelVisible
            if let active = activeDemo {
                currentDisplayURL = active.url
            }
        } else {
            loadSampleData()
        }
    }

    private func saveToDisk() {
        let doc = DemoBrowserDocument(
            demos: demos,
            activeDemoID: activeDemoID,
            isNotesPanelVisible: isNotesPanelVisible
        )
        PersistenceService.save(doc)
    }

    private func scheduleAutoSave() {
        saveSubject.send()
    }

    private func loadSampleData() {
        let sample1 = Demo(name: "Apple", url: "https://www.apple.com")
        let sample2 = Demo(name: "GitHub", url: "https://github.com")
        let sample3 = Demo(name: "Wikipedia", url: "https://en.wikipedia.org")
        demos = [sample1, sample2, sample3]
        activeDemoID = sample1.id
        currentDisplayURL = sample1.url
        scheduleAutoSave()
    }

    func selectDemo(_ demo: Demo) {
        activeDemoID = demo.id
        currentDisplayURL = demo.url
        sessionEpoch += 1
        scheduleAutoSave()
    }

    func addDemo(name: String = "New Demo", url: String = "https://www.apple.com") {
        let demo = Demo(name: name, url: url)
        demos.append(demo)
        selectDemo(demo)
        editingDemoID = demo.id
    }

    func duplicateActiveDemo() {
        guard let active = activeDemo else { return }
        let copy = Demo(name: "\(active.name) Copy", url: active.url, notes: active.notes)
        demos.append(copy)
        selectDemo(copy)
    }

    func deleteActiveDemo() {
        guard let id = activeDemoID else { return }
        demos.removeAll { $0.id == id }
        if let first = demos.first {
            selectDemo(first)
        } else {
            activeDemoID = nil
            currentDisplayURL = ""
            sessionEpoch += 1
        }
        scheduleAutoSave()
    }

    func refreshSession() {
        sessionEpoch += 1
        if let active = activeDemo {
            currentDisplayURL = active.url
        }
    }

    func updateCurrentDisplayURL(_ url: String) {
        currentDisplayURL = url
    }

    func navigateTo(_ urlString: String) {
        var normalized = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        if !normalized.hasPrefix("http://") && !normalized.hasPrefix("https://") {
            normalized = "https://\(normalized)"
        }
        currentDisplayURL = normalized
        sessionEpoch += 1
    }

    func updateDemoName(_ id: UUID, name: String) {
        guard let idx = demos.firstIndex(where: { $0.id == id }) else { return }
        demos[idx].name = name
        scheduleAutoSave()
    }

    func updateDemoURL(_ id: UUID, url: String) {
        guard let idx = demos.firstIndex(where: { $0.id == id }) else { return }
        demos[idx].url = url
        if id == activeDemoID {
            currentDisplayURL = url
            sessionEpoch += 1
        }
        scheduleAutoSave()
    }

    func updateNotes(_ notes: String) {
        guard let id = activeDemoID, let idx = demos.firstIndex(where: { $0.id == id }) else { return }
        demos[idx].notes = notes
        scheduleAutoSave()
    }

    func toggleNotesPanel() {
        isNotesPanelVisible.toggle()
        scheduleAutoSave()
    }

    func toggleChrome() {
        isChromeVisible.toggle()
    }
}

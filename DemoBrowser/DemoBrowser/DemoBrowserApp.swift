import SwiftUI

@main
struct DemoBrowserApp: App {
    @State private var store = DemoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
        .defaultSize(width: 1200, height: 800)
    }
}

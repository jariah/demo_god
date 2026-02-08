import SwiftUI

struct DemoQueueView: View {
    @Environment(DemoStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Demo Queue")
                    .font(.headline)
                Spacer()
                Button(action: { store.addDemo() }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            List(selection: Binding(
                get: { store.activeDemoID },
                set: { newID in
                    if let id = newID, let demo = store.demos.first(where: { $0.id == id }) {
                        store.selectDemo(demo)
                    }
                }
            )) {
                ForEach(store.demos) { demo in
                    DemoRowView(demo: demo)
                        .tag(demo.id)
                }
            }
            .listStyle(.sidebar)
        }
    }
}

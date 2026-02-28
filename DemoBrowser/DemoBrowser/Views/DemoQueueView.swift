import SwiftUI

struct DemoQueueView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs

    var body: some View {
        VStack(spacing: 0) {
            // Fixed header — does not scroll
            HStack {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text("DEMOGOD")
                    .font(.system(size: 14, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white)

                Spacer()

                Button(action: {
                    store.addDemo()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(store.demos) { demo in
                        DemoRowView(demo: demo)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if store.activeDemoID != demo.id {
                                    store.selectDemo(demo)
                                }
                            }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

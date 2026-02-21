import SwiftUI

struct DemoQueueView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image("DemoGodHeader")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 42)

                Spacer()

                Button(action: {
                    store.addDemo()
                }) {
                    Text("+")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.primary)
                        .frame(width: 42, height: 42)
                        .background(Color(nsColor: .tertiarySystemFill), in: RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(store.demos) { demo in
                        DemoRowView(demo: demo)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if store.activeDemoID != demo.id {
                                    store.selectDemo(demo)
                                }
                            }
                    }
                }
            }
        }
    }
}

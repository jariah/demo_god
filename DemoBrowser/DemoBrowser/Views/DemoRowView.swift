import SwiftUI

struct DemoRowView: View {
    let demo: Demo

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(demo.name)
                .font(.body)
                .lineLimit(1)
            Text(demo.url)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
}

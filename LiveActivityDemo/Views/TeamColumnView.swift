import SwiftUI

struct TeamColumnView: View {
    let name: String
    let emoji: String
    let score: Int
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.largeTitle)
            Text(name)
                .font(.headline)
            if isActive {
                Text("\(score)")
                    .font(.largeTitle.bold())
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

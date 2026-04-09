import SwiftUI

struct ScoreboardView: View {
    let homeTeam: String
    let awayTeam: String
    let homeEmoji: String
    let awayEmoji: String
    let homeScore: Int
    let awayScore: Int
    let isActive: Bool
    let period: Int
    let gameTime: String

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TeamColumnView(name: homeTeam, emoji: homeEmoji, score: homeScore, isActive: isActive)
                VStack {
                    Text("vs")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    if isActive {
                        Text("Q\(period)")
                            .font(.caption.bold())
                        Text(gameTime)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 60)
                TeamColumnView(name: awayTeam, emoji: awayEmoji, score: awayScore, isActive: isActive)
            }
        }
        .padding(.vertical, 8)
    }
}

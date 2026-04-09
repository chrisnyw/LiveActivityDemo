import ActivityKit
import SwiftUI
import WidgetKit

struct SportsGameLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SportsGameAttributes.self) { context in
            SportsLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(spacing: 4) {
                        Text(context.attributes.homeEmoji)
                            .font(.title2)
                        Text(context.attributes.homeTeam)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(spacing: 4) {
                        Text(context.attributes.awayEmoji)
                            .font(.title2)
                        Text(context.attributes.awayTeam)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack(spacing: 12) {
                        Text("\(context.state.homeScore)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        VStack(spacing: 2) {
                            Text(context.state.period)
                                .font(.caption2.bold())
                            Text(context.state.gameTime)
                                .font(.caption2.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        Text("\(context.state.awayScore)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .monospacedDigit()
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if let event = context.state.lastEvent {
                        Text(event)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Text(context.attributes.homeEmoji)
                        .font(.caption)
                    Text("\(context.state.homeScore)")
                        .font(.headline.monospacedDigit())
                }
            } compactTrailing: {
                HStack(spacing: 4) {
                    Text("\(context.state.awayScore)")
                        .font(.headline.monospacedDigit())
                    Text(context.attributes.awayEmoji)
                        .font(.caption)
                }
            } minimal: {
                Text("\(context.state.homeScore)-\(context.state.awayScore)")
                    .font(.caption2.bold().monospacedDigit())
            }
        }
    }
}

// MARK: - Lock Screen View

private struct SportsLockScreenView: View {
    let context: ActivityViewContext<SportsGameAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                SportsTeamView(
                    emoji: context.attributes.homeEmoji,
                    name: context.attributes.homeTeam,
                    score: context.state.homeScore
                )

                VStack(spacing: 4) {
                    Text(context.state.period)
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.white.opacity(0.15))
                        .clipShape(Capsule())
                    Text(context.state.gameTime)
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                .frame(width: 60)

                SportsTeamView(
                    emoji: context.attributes.awayEmoji,
                    name: context.attributes.awayTeam,
                    score: context.state.awayScore
                )
            }

            if let event = context.state.lastEvent {
                Text(event)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .activityBackgroundTint(.black.opacity(0.8))
    }
}

// MARK: - Sports Team View

private struct SportsTeamView: View {
    let emoji: String
    let name: String
    let score: Int

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.title)
            Text(name)
                .font(.caption.bold())
            Text("\(score)")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }
}

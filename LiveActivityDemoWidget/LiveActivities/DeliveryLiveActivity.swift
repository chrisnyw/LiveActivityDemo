import ActivityKit
import SwiftUI
import WidgetKit

struct DeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // Lock Screen / Banner presentation
            DeliveryLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.status.icon)
                        .font(.title2)
                        .foregroundStyle(.orange)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        CountdownText(to: context.state.estimatedDeliveryTime)
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(.orange)
                        Text("ETA")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 4) {
                        Text(context.state.status.title)
                            .font(.headline)
                        Text(context.attributes.restaurantName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    DeliveryProgressBar(progress: context.state.status.progress)
                        .padding(.top, 4)
                }
            } compactLeading: {
                Image(systemName: context.state.status.icon)
                    .foregroundStyle(.orange)
            } compactTrailing: {
                CountdownText(to: context.state.estimatedDeliveryTime)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.orange)
                    .frame(minWidth: 36)
            } minimal: {
                Image(systemName: context.state.status.icon)
                    .foregroundStyle(.orange)
            }
        }
    }
}

// MARK: - Lock Screen View

private struct DeliveryLockScreenView: View {
    let context: ActivityViewContext<DeliveryAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: context.state.status.icon)
                    .font(.title2)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.status.title)
                        .font(.headline)
                    Text("\(context.attributes.restaurantName) — #\(context.attributes.orderNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    CountdownText(to: context.state.estimatedDeliveryTime)
                        .font(.title3.bold().monospacedDigit())
                        .foregroundStyle(.orange)
                    Text("ETA")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            DeliveryProgressBar(progress: context.state.status.progress)

            HStack {
                Text("Courier: \(context.state.courierName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding()
        .activityBackgroundTint(.black.opacity(0.8))
    }
}

// MARK: - Countdown Text

private struct CountdownText: View {
    let to: Date

    var body: some View {
        if to > .now {
            Text(timerInterval: .now...to, countsDown: true, showsHours: false)
        } else {
            Text("0:00")
        }
    }
}

// MARK: - Progress Bar

private struct DeliveryProgressBar: View {
    let progress: Double

    var body: some View {
        Capsule()
            .fill(.white.opacity(0.2))
            .frame(height: 6)
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.orange)
                    .scaleEffect(x: progress, anchor: .leading)
            }
    }
}

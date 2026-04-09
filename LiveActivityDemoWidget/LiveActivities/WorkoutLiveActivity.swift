import ActivityKit
import SwiftUI
import WidgetKit

struct WorkoutLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutAttributes.self) { context in
            WorkoutLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: context.attributes.workoutType.icon)
                            .font(.title2)
                            .foregroundStyle(.blue)
                        Text(context.attributes.workoutType.title)
                            .font(.caption2)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(context.state.formattedTime)
                            .font(.title3.bold().monospacedDigit())
                            .foregroundStyle(.blue)
                        Text("Elapsed")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 16) {
                        WorkoutStatView(
                            icon: "heart.fill",
                            value: "\(context.state.heartRate)",
                            unit: "BPM",
                            color: .red
                        )
                        WorkoutStatView(
                            icon: "flame.fill",
                            value: "\(context.state.caloriesBurned)",
                            unit: "CAL",
                            color: .orange
                        )
                        WorkoutStatView(
                            icon: "location.fill",
                            value: context.state.formattedDistance,
                            unit: context.attributes.workoutType.unit,
                            color: .green
                        )
                    }
                }
            } compactLeading: {
                Image(systemName: context.attributes.workoutType.icon)
                    .foregroundStyle(.blue)
            } compactTrailing: {
                Text(context.state.formattedTime)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.blue)
                    .frame(minWidth: 36)
            } minimal: {
                Image(systemName: context.attributes.workoutType.icon)
                    .foregroundStyle(.blue)
            }
        }
    }
}

// MARK: - Workout Stat View

private struct WorkoutStatView: View {
    let icon: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text(value)
                .font(.caption.bold().monospacedDigit())
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Lock Screen View

private struct WorkoutLockScreenView: View {
    let context: ActivityViewContext<WorkoutAttributes>

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: context.attributes.workoutType.icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text(context.attributes.workoutType.title)
                        .font(.headline)
                    Text(context.attributes.startTime, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(context.state.formattedTime)
                    .font(.title2.bold().monospaced())
                    .foregroundStyle(.blue)
            }

            HStack(spacing: 20) {
                LockScreenStatView(
                    icon: "heart.fill",
                    value: "\(context.state.heartRate)",
                    unit: "BPM",
                    color: .red
                )
                LockScreenStatView(
                    icon: "flame.fill",
                    value: "\(context.state.caloriesBurned)",
                    unit: "CAL",
                    color: .orange
                )
                LockScreenStatView(
                    icon: "location.fill",
                    value: context.state.formattedDistance,
                    unit: context.attributes.workoutType.unit,
                    color: .green
                )
            }
        }
        .padding()
        .activityBackgroundTint(.black.opacity(0.8))
    }
}

// MARK: - Lock Screen Stat View

private struct LockScreenStatView: View {
    let icon: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.headline.monospacedDigit())
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

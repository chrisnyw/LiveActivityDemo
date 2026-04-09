import SwiftUI

struct WorkoutCard: View {
    let selectedType: WorkoutType
    let isActive: Bool
    let formattedTime: String
    let heartRate: Int
    let calories: Int
    let distance: Double

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: selectedType.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading) {
                    Text(selectedType.title)
                        .font(.title2.bold())
                    Text(isActive ? "In Progress" : "Ready")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if isActive {
                    Text(formattedTime)
                        .font(.title2.bold().monospaced())
                        .foregroundStyle(.blue)
                }
            }

            if isActive {
                HStack(spacing: 24) {
                    StatItemView(icon: "heart.fill", value: "\(heartRate)", unit: "BPM", color: .red)
                    StatItemView(icon: "flame.fill", value: "\(calories)", unit: "CAL", color: .orange)
                    StatItemView(
                        icon: "location.fill",
                        value: distance.formatted(.number.precision(.fractionLength(2))),
                        unit: selectedType.unit,
                        color: .green
                    )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

import SwiftUI

struct DeliveryStatusCard: View {
    let currentStatus: DeliveryStatus
    let isActive: Bool

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: currentStatus.icon)
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading) {
                    Text(currentStatus.title)
                        .font(.title2.bold())
                    if isActive {
                        Text("Order #12345 from Joe's Pizza")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Ready to start")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }

            ProgressView(value: currentStatus.progress)
                .tint(.orange)

            HStack {
                ForEach(DeliveryStatus.allCases, id: \.self) { status in
                    VStack(spacing: 4) {
                        Image(systemName: status.icon)
                            .font(.caption)
                            .foregroundStyle(status.progress <= currentStatus.progress ? .orange : .secondary)
                        Text(status.title)
                            .font(.caption2)
                            .foregroundStyle(status.progress <= currentStatus.progress ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(DemoType.allCases) { demo in
                NavigationLink(value: demo) {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(demo.title)
                                .font(.headline)
                            Text(demo.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: demo.icon)
                            .foregroundStyle(colorForDemo(demo))
                            .font(.title2)
                            .frame(width: 32)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Live Activity Demos")
            .navigationDestination(for: DemoType.self) { demo in
                switch demo {
                case .delivery:
                    DeliveryDemoView()
                case .sportsGame:
                    SportsScoreDemoView()
                case .workout:
                    WorkoutTimerDemoView()
                }
            }
        }
    }

    private func colorForDemo(_ demo: DemoType) -> Color {
        switch demo {
        case .delivery: .orange
        case .sportsGame: .green
        case .workout: .blue
        }
    }
}

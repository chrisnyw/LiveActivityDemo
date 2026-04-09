import Foundation

enum WorkoutType: String, Codable, CaseIterable {
    case running
    case cycling
    case swimming

    var title: String {
        switch self {
        case .running: "Running"
        case .cycling: "Cycling"
        case .swimming: "Swimming"
        }
    }

    var icon: String {
        switch self {
        case .running: "figure.run"
        case .cycling: "figure.outdoor.cycle"
        case .swimming: "figure.pool.swim"
        }
    }

    var unit: String {
        switch self {
        case .running, .cycling: "km"
        case .swimming: "m"
        }
    }
}

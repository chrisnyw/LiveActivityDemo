import Foundation

enum DemoType: String, CaseIterable, Identifiable {
    case delivery
    case sportsGame
    case workout

    var id: String { rawValue }

    var title: String {
        switch self {
        case .delivery: "Delivery Tracker"
        case .sportsGame: "Sports Score"
        case .workout: "Workout Timer"
        }
    }

    var subtitle: String {
        switch self {
        case .delivery: "Track food delivery with live status updates"
        case .sportsGame: "Follow a live basketball game score"
        case .workout: "Monitor an active workout session"
        }
    }

    var icon: String {
        switch self {
        case .delivery: "bicycle"
        case .sportsGame: "sportscourt.fill"
        case .workout: "figure.run"
        }
    }

    var color: String {
        switch self {
        case .delivery: "orange"
        case .sportsGame: "green"
        case .workout: "blue"
        }
    }
}

import Foundation

enum DeliveryStatus: String, Codable, CaseIterable {
    case preparing
    case pickedUp
    case onTheWay
    case delivered

    var title: String {
        switch self {
        case .preparing: "Preparing"
        case .pickedUp: "Picked Up"
        case .onTheWay: "On the Way"
        case .delivered: "Delivered"
        }
    }

    var icon: String {
        switch self {
        case .preparing: "frying.pan"
        case .pickedUp: "bag.fill"
        case .onTheWay: "car.fill"
        case .delivered: "checkmark.circle.fill"
        }
    }

    var progress: Double {
        switch self {
        case .preparing: 0.25
        case .pickedUp: 0.5
        case .onTheWay: 0.75
        case .delivered: 1.0
        }
    }

    var next: DeliveryStatus? {
        switch self {
        case .preparing: .pickedUp
        case .pickedUp: .onTheWay
        case .onTheWay: .delivered
        case .delivered: nil
        }
    }
}

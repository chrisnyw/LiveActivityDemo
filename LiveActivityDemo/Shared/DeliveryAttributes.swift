import ActivityKit
import Foundation

struct DeliveryAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: DeliveryStatus
        var courierName: String
        var estimatedDeliveryTime: Date
    }

    var orderNumber: String
    var restaurantName: String
}

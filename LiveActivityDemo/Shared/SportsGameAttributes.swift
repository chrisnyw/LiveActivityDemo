import ActivityKit
import Foundation

struct SportsGameAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var homeScore: Int
        var awayScore: Int
        var gameTime: String
        var period: String
        var lastEvent: String?
    }

    var homeTeam: String
    var awayTeam: String
    var homeEmoji: String
    var awayEmoji: String
}

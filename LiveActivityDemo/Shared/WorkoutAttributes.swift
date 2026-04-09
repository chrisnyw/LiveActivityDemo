import ActivityKit
import Foundation

struct WorkoutAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var elapsedSeconds: Int
        var heartRate: Int
        var caloriesBurned: Int
        var distance: Double

        var formattedTime: String {
            Duration.seconds(elapsedSeconds).formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
        }

        var formattedDistance: String {
            distance.formatted(.number.precision(.fractionLength(2)))
        }
    }

    var workoutType: WorkoutType
    var startTime: Date
}

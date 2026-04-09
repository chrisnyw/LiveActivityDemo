import ActivityKit
import Foundation
import Observation

@MainActor
@Observable
final class SportsScoreDemoViewModel {
    var homeScore = 0
    var awayScore = 0
    var period = 1 {
        didSet {
            guard isActive, oldValue != period else { return }
            gameTime = "12:00"
            updateActivity(event: "Q\(period) starts")
        }
    }
    var gameTime = "12:00"
    var showError = false
    var errorMessage = ""

    let homeTeam = "Lakers"
    let awayTeam = "Celtics"
    let homeEmoji = "\u{1F49C}"
    let awayEmoji = "\u{1F49A}"

    private(set) var activity: Activity<SportsGameAttributes>?

    var isActive: Bool { activity != nil }

    func scoreHome(points: Int) {
        homeScore += points
        let event = points == 3 ? "\(homeTeam) three-pointer!" : "\(homeTeam) scores! +\(points)"
        updateActivity(event: event)
    }

    func scoreAway(points: Int) {
        awayScore += points
        let event = points == 3 ? "\(awayTeam) three-pointer!" : "\(awayTeam) scores! +\(points)"
        updateActivity(event: event)
    }

    func startActivity() {
        Task {
            await endAllLiveActivities()

            let attributes = SportsGameAttributes(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                homeEmoji: homeEmoji,
                awayEmoji: awayEmoji
            )
            homeScore = 0
            awayScore = 0
            period = 1
            gameTime = "12:00"

            let state = SportsGameAttributes.ContentState(
                homeScore: 0,
                awayScore: 0,
                gameTime: gameTime,
                period: "Q1",
                lastEvent: "Tip-off!"
            )
            let content = ActivityContent(state: state, staleDate: nil)

            do {
                activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    func advanceClock() {
        let parts = gameTime.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return }
        var minutes = parts[0]
        var seconds = parts[1]

        seconds -= 24
        if seconds < 0 {
            minutes -= 1
            seconds += 60
        }
        if minutes < 0 {
            minutes = 0
            seconds = 0
        }
        gameTime = Duration.seconds(minutes * 60 + seconds).formatted(.time(pattern: .minuteSecond))
        updateActivity(event: nil)
    }

    func endActivity() {
        let state = SportsGameAttributes.ContentState(
            homeScore: homeScore,
            awayScore: awayScore,
            gameTime: "Final",
            period: "Q\(period)",
            lastEvent: "Game Over"
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(content, dismissalPolicy: .after(.now + 60))
            activity = nil
            homeScore = 0
            awayScore = 0
        }
    }

    // MARK: - Private

    private func updateActivity(event: String?) {
        let state = SportsGameAttributes.ContentState(
            homeScore: homeScore,
            awayScore: awayScore,
            gameTime: gameTime,
            period: "Q\(period)",
            lastEvent: event
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.update(content)
        }
    }
}

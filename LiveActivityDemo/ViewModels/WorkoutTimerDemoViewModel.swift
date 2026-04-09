import ActivityKit
import Foundation
import Observation

@MainActor
@Observable
final class WorkoutTimerDemoViewModel {
    var selectedType: WorkoutType = .running
    var elapsedSeconds = 0
    var heartRate = 72
    var calories = 0
    var distance = 0.0
    var showError = false
    var errorMessage = ""

    private(set) var activity: Activity<WorkoutAttributes>?
    private var timer: Timer?

    var isActive: Bool { activity != nil }

    var formattedTime: String {
        Duration.seconds(elapsedSeconds).formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
    }

    func startWorkout() {
        Task {
            await endAllLiveActivities()

            elapsedSeconds = 0
            heartRate = 72
            calories = 0
            distance = 0.0

            let attributes = WorkoutAttributes(
                workoutType: selectedType,
                startTime: .now
            )
            let state = WorkoutAttributes.ContentState(
                elapsedSeconds: 0,
                heartRate: heartRate,
                caloriesBurned: 0,
                distance: 0.0
            )
            let content = ActivityContent(state: state, staleDate: nil)

            do {
                activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                startTimer()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    func endWorkout() {
        timer?.invalidate()
        timer = nil

        let state = WorkoutAttributes.ContentState(
            elapsedSeconds: elapsedSeconds,
            heartRate: heartRate,
            caloriesBurned: calories,
            distance: distance
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(content, dismissalPolicy: .after(.now + 30))
            activity = nil
            elapsedSeconds = 0
        }
    }

    // MARK: - Timer

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.timerTick()
            }
        }
    }

    private func timerTick() {
        guard activity?.activityState == .active else {
            timer?.invalidate()
            timer = nil
            activity = nil
            elapsedSeconds = 0
            return
        }

        elapsedSeconds += 1
        heartRate = simulateHeartRate()
        calories = Int(Double(elapsedSeconds) * 0.15)
        distance += simulateDistanceIncrement()

        if elapsedSeconds % 5 == 0 {
            updateActivity()
        }
    }

    private func simulateHeartRate() -> Int {
        let base = 120 + min(elapsedSeconds / 10, 40)
        let variation = Int.random(in: -3...3)
        return base + variation
    }

    private func simulateDistanceIncrement() -> Double {
        switch selectedType {
        case .running: Double.random(in: 0.002...0.004)
        case .cycling: Double.random(in: 0.006...0.01)
        case .swimming: Double.random(in: 0.5...1.5)
        }
    }

    private func updateActivity() {
        let state = WorkoutAttributes.ContentState(
            elapsedSeconds: elapsedSeconds,
            heartRate: heartRate,
            caloriesBurned: calories,
            distance: distance
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.update(content)
        }
    }
}

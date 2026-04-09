import ActivityKit
import Foundation
import Observation

@MainActor
@Observable
final class DeliveryDemoViewModel {
    var currentStatus: DeliveryStatus = .preparing
    var courierName = "Alex"
    var estimatedSeconds = 30
    var showError = false
    var errorMessage = ""

    private(set) var activity: Activity<DeliveryAttributes>?
    private var deliveryStartTime: Date?
    private var deliveryEndTime: Date?
    private var autoAdvanceTimer: Timer?

    var isActive: Bool { activity != nil }

    func startActivity() {
        Task {
            await endAllLiveActivities()

            let startTime = Date.now
            let endTime = startTime.addingTimeInterval(TimeInterval(estimatedSeconds))
            deliveryStartTime = startTime
            deliveryEndTime = endTime

            let attributes = DeliveryAttributes(
                orderNumber: "12345",
                restaurantName: "Joe's Pizza"
            )
            let state = DeliveryAttributes.ContentState(
                status: .preparing,
                courierName: courierName,
                estimatedDeliveryTime: endTime
            )
            let content = ActivityContent(state: state, staleDate: nil)

            do {
                activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                currentStatus = .preparing
                startAutoAdvanceTimer()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    func advanceStatus(to status: DeliveryStatus) {
        guard status.progress > currentStatus.progress else { return }
        currentStatus = status

        guard let endTime = deliveryEndTime else { return }

        let state = DeliveryAttributes.ContentState(
            status: status,
            courierName: courierName,
            estimatedDeliveryTime: endTime
        )

        if status == .delivered {
            autoAdvanceTimer?.invalidate()
            autoAdvanceTimer = nil
            let content = ActivityContent(state: state, staleDate: nil)
            Task {
                await activity?.end(content, dismissalPolicy: .after(.now + 30))
                activity = nil
            }
        } else {
            let content = ActivityContent(state: state, staleDate: nil)
            Task {
                await activity?.update(content)
            }
        }
    }

    func endActivity() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil

        let state = DeliveryAttributes.ContentState(
            status: currentStatus,
            courierName: courierName,
            estimatedDeliveryTime: .now
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
            activity = nil
            currentStatus = .preparing
            deliveryStartTime = nil
            deliveryEndTime = nil
        }
    }

    func cleanup() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil
    }

    // MARK: - Auto-Advance Timer

    private func startAutoAdvanceTimer() {
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.checkAutoAdvance()
            }
        }
    }

    private func checkAutoAdvance() {
        guard activity?.activityState == .active else {
            autoAdvanceTimer?.invalidate()
            autoAdvanceTimer = nil
            activity = nil
            currentStatus = .preparing
            return
        }

        guard let startTime = deliveryStartTime, let endTime = deliveryEndTime else { return }
        let totalDuration = endTime.timeIntervalSince(startTime)
        guard totalDuration > 0 else { return }
        let elapsed = Date.now.timeIntervalSince(startTime)
        let progress = elapsed / totalDuration

        let expectedStatus: DeliveryStatus
        if progress >= 1.0 {
            expectedStatus = .delivered
        } else if progress >= 0.66 {
            expectedStatus = .onTheWay
        } else if progress >= 0.33 {
            expectedStatus = .pickedUp
        } else {
            expectedStatus = .preparing
        }

        if expectedStatus.progress > currentStatus.progress {
            advanceStatus(to: expectedStatus)
        }
    }
}

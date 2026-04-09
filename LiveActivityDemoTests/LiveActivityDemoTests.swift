@testable import LiveActivityDemo
import Testing

@Test func deliveryStatusProgression() {
    #expect(DeliveryStatus.preparing.next == .pickedUp)
    #expect(DeliveryStatus.pickedUp.next == .onTheWay)
    #expect(DeliveryStatus.onTheWay.next == .delivered)
    #expect(DeliveryStatus.delivered.next == nil)
}

@Test func deliveryStatusProgress() {
    #expect(DeliveryStatus.preparing.progress == 0.25)
    #expect(DeliveryStatus.delivered.progress == 1.0)
}

@Test func workoutFormattedTime() {
    let state = WorkoutAttributes.ContentState(
        elapsedSeconds: 125,
        heartRate: 140,
        caloriesBurned: 200,
        distance: 1.5
    )
    #expect(state.formattedTime == "02:05")
}

@Test func workoutFormattedDistance() {
    let state = WorkoutAttributes.ContentState(
        elapsedSeconds: 60,
        heartRate: 120,
        caloriesBurned: 100,
        distance: 3.456
    )
    #expect(state.formattedDistance == "3.46")
}

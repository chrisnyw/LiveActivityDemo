import ActivityKit

func endAllLiveActivities() async {
    for activity in Activity<DeliveryAttributes>.activities {
        await activity.end(dismissalPolicy: .immediate)
    }
    for activity in Activity<SportsGameAttributes>.activities {
        await activity.end(dismissalPolicy: .immediate)
    }
    for activity in Activity<WorkoutAttributes>.activities {
        await activity.end(dismissalPolicy: .immediate)
    }
}

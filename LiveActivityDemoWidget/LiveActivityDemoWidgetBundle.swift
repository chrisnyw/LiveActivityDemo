import SwiftUI
import WidgetKit

@main
struct LiveActivityDemoWidgetBundle: WidgetBundle {
    var body: some Widget {
        DeliveryLiveActivity()
        SportsGameLiveActivity()
        WorkoutLiveActivity()
    }
}

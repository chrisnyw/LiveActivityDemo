import XCTest

final class LiveActivityDemoUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testNavigationToDeliveryDemo() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Delivery Tracker"].exists)
        app.staticTexts["Delivery Tracker"].tap()
        XCTAssertTrue(app.navigationBars["Delivery Tracker"].exists)
    }

    @MainActor
    func testNavigationToSportsDemo() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Sports Score"].exists)
        app.staticTexts["Sports Score"].tap()
        XCTAssertTrue(app.navigationBars["Sports Score"].exists)
    }

    @MainActor
    func testNavigationToWorkoutDemo() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["Workout Timer"].exists)
        app.staticTexts["Workout Timer"].tap()
        XCTAssertTrue(app.navigationBars["Workout Timer"].exists)
    }
}

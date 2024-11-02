// UITests.swift

import XCTest

final class UITests: XCTestCase {
    var app: XCUIApplication!
    var appViewPage: AppViewPage!

    override func setUpWithError() throws {
        // Initialize the app and the page object
        app = XCUIApplication()
        app.launch()

        appViewPage = AppViewPage(app: app)

        // Continue after failure is set to false for immediate test interruption on failure
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
        appViewPage = nil
    }

    // Test to verify if tapping on a grid cell navigates to the detail view
    @MainActor
    func testNavigateToDetailView() throws {
        // Tap the first character cell
        appViewPage.tapCharacterCell(at: 0)

        // Assert that the detail view is displayed after tapping a cell
        XCTAssertTrue(appViewPage.detailViewTitle.exists, "Tapping a character cell should navigate to the Detail view")

        // Navigate back to the grid view
        appViewPage.navigateBack()

        // Confirm we are back in the MarvelGrid view
        XCTAssertTrue(appViewPage.navigationStack.exists, "Navigating back should return to the MarvelGrid view")
    }

    // Test to check that "No Data" view is shown when there are no characters in the grid
    @MainActor
    func testNoDataViewAppearsWhenGridIsEmpty() throws {
        // Assume there are no characters, causing the "No Data" view to appear
        XCTAssertTrue(appViewPage.isNoDataViewVisible(), "NoDataView should be visible when the grid is empty")
    }

    // Performance test for measuring app launch time
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

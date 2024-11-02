// AppViewPage.swift


import XCTest

class AppViewPage {
    let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // MARK: - UI Elements
    
    var navigationStack: XCUIElement {
        return app.navigationBars["MarvelGrid"]
    }
    
    var gridCells: XCUIElementQuery {
        return app.cells.matching(identifier: "GridCell")
    }
    
    var noDataView: XCUIElement {
        return app.staticTexts["NoDataView"]
    }
    
    var detailViewTitle: XCUIElement {
        return app.staticTexts["Detail"]
    }
    
    // MARK: - Actions
    
    /// Tap on a character cell at the given index
    func tapCharacterCell(at index: Int) {
        let cell = gridCells.element(boundBy: index)
        XCTAssertTrue(cell.exists, "Grid cell at index \(index) should exist")
        cell.tap()
    }
    
    /// Checks if the "No Data" view is visible
    func isNoDataViewVisible() -> Bool {
        return noDataView.exists
    }
    
    /// Navigate back to MarvelGrid from Detail
    func navigateBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
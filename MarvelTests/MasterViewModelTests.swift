// Author: Tom Fu
import XCTest
@testable import Marvel

@MainActor
final class MasterViewModelTests: XCTestCase {
    var viewModel: GridModel!

    override func setUp() {
        super.setUp()
        viewModel = GridModel(.characters) // Initialize model instance
    }

    override func tearDown() {
        viewModel = nil // Clean up after each test
        super.tearDown()
    }

    func test_decode_json_should_correct() async throws {
        try await viewModel.fetch(0, client: MockMarvelClient()) // Inject Mock client
        XCTAssertEqual(viewModel.characters.count, 20)
    }

    func test_load_more_page_correct() async throws {
        try await viewModel.fetch(0, client: MockMarvelClient())
        guard let last = viewModel.characters.last else {
            XCTFail("Expected to have characters loaded, but found none.")
            return
        }
        // Act: Attempt to load more based on the last character
        let canLoadMore = await viewModel.loadMoreIfCan(last)

        // Assert: Verify that loading more is possible
        XCTAssertTrue(canLoadMore, "Expected to be able to load more pages, but loadMoreIfCan returned false.")
    }
}

// Author: Tom Fu
import Foundation

@MainActor
final class GridModel: ObservableObject {

    @Published private(set) var characters: [Character]
    var charId: String = ""
    var total = 0

    private var offset = 0
    private var hasMore: Bool = true
    private let endPoint: Marvel.EndPoint

    init(_ endPoint: Marvel.EndPoint, characters: [Character] = []) {
        self.endPoint = endPoint
        self.characters = characters
    }

    func fetch(_ offset: Int = 0, client: MarvelProtocol = MarvelClient()) async throws {
        let marvelClient = MarvelClient()
        let response = try? await marvelClient.fetch(endPoint: endPoint, offset, charId: charId)

        guard let response else {
            return
        }
        toModel(data: response.data)
    }

    private func toModel(data: PaginatedInfo<Character>) {
        let newCharacters = data.results ?? []
        characters.append(contentsOf: newCharacters)
        offset = data.offset + data.count
        total = data.total
        hasMore = data.count == data.limit
    }

    @discardableResult
    func loadMoreIfCan(_ character: Character) async -> Bool {
        guard canLoadMore(character) else {
            return false
        }

        // Await the fetch operation
        do {
            try await fetch(offset)
            return true
        } catch {
            // Handle error if needed, and return false if fetch fails
            print("Failed to load more: \(error)")
            return false
        }
    }

    private func canLoadMore(_ character: Character) -> Bool {
        characters.isLast(character) && hasMore && characters.count != total
    }
}

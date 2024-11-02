// MockMarvelClient.swift
@testable import Marvel

final class MockMarvelClient: MarvelProtocol {
    func fetch(endPoint: Marvel.EndPoint, _ offset: Int, charId: String) async throws -> MarvelResponse {
        let data = PaginatedInfo(offset: offset, limit: 20, total: 100, count: 11, results: Character.mock)
        return MarvelResponse(code: 0, status: "200", data: data)
    }
}

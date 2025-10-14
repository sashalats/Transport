import OpenAPIURLSession
import OpenAPIRuntime
import Foundation
protocol ThreadRouteServiceProtocol {
    func getRouteStations(
        apikey: String,
        uid: String,
        from: String?,
        to: String?,
        date: String?,
        showSystems: String?,
        lang: String?,
        format: String?) async throws -> ThreadStationsResponse
}

final class ThreadRouteService: ThreadRouteServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getRouteStations(
        apikey: String,
        uid: String,
        from: String?,
        to: String?,
        date: String?,
        showSystems: String?,
        lang: String?,
        format: String?
    ) async throws -> ThreadStationsResponse {
        let resp = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            from: from,
            to: to,
            format: format,
            lang: lang,
            date: date,
            show_systems: showSystems
        ))
        return try resp.ok.body.json
    }
}

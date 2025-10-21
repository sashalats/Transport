import OpenAPIURLSession
import OpenAPIRuntime
import Foundation

protocol NearestCityServiceProtocol {
    func getNearestCity(
        apikey: String,
        lat: Double,
        lng: Double,
        distance: Int?,
        lang: String?,
        format: String?) async throws -> NearestCityResponse
}

final class NearestCityService: NearestCityServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getNearestCity(
        apikey: String,
        lat: Double,
        lng: Double,
        distance: Int?,
        lang: String?,
        format: String?
    ) async throws -> NearestCityResponse {
        let resp = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance,
            lang: lang,
            format: format
        ))
        return try resp.ok.body.json
    }
}

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

protocol NearestStationsServiceProtocol {
    func getNearestStations(
        apikey: String,
        lat: Double,
        lng: Double,
        distance: Int,
        lang: String?,
        format: String?,
        stationTypes: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?) async throws -> NearestStations
}

final class NearestStationsService: NearestStationsServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getNearestStations(
        apikey: String,
        lat: Double,
        lng: Double,
        distance: Int,
        lang: String?,
        format: String?,
        stationTypes: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?
    ) async throws -> NearestStations {
        let response = try await client.getNearestStations(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance,
            lang: lang,
            format: format,
            station_types: stationTypes,
            transport_types: transportTypes,
            offset: offset,
            limit: limit
        ))
        return try response.ok.body.json
    }
}

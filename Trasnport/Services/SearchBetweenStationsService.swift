import OpenAPIURLSession
import OpenAPIRuntime
import Foundation
protocol SearchBetweenStationsServiceProtocol {
    func getSegments(
        apikey: String,
        from: String,
        to: String,
        date: String?,
        format: String?,
        lang: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?,
        resultTimezone: String?,
        transfers: Bool?) async throws -> SegmentsResponse
}

final class SearchBetweenStationsService: SearchBetweenStationsServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getSegments(
        apikey: String,
        from: String,
        to: String,
        date: String?,
        format: String?,
        lang: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?,
        resultTimezone: String?,
        transfers: Bool?
    ) async throws -> SegmentsResponse {
        let resp = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: format,
            lang: lang,
            date: date,
            transport_types: transportTypes,
            offset: offset,
            limit: limit,
            result_timezone: resultTimezone,
            transfers: transfers
        ))
        return try resp.ok.body.json
    }
}

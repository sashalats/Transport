import OpenAPIURLSession
import OpenAPIRuntime
import Foundation

protocol StationScheduleServiceProtocol {
    func getStationSchedule(
        apikey: String,
        station: String,
        date: String?,
        lang: String?,
        format: String?,
        transportTypes: String?,
        event: String?,
        direction: String?,
        system: String?,
        resultTimezone: String?) async throws -> StationScheduleResponse
}

final class StationScheduleService: StationScheduleServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getStationSchedule(
        apikey: String,
        station: String,
        date: String?,
        lang: String?,
        format: String?,
        transportTypes: String?,
        event: String?,
        direction: String?,
        system: String?,
        resultTimezone: String?
    ) async throws -> StationScheduleResponse {
        let resp = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            lang: lang,
            format: format,
            date: date,
            transport_types: transportTypes,
            event: event,
            direction: direction,
            system: system,
            result_timezone: resultTimezone
        ))
        return try resp.ok.body.json
    }
}

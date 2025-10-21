import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStations          = Components.Schemas.Stations
typealias SegmentsResponse         = Components.Schemas.Segments
typealias StationScheduleResponse  = Components.Schemas.ScheduleResponse
typealias ThreadStationsResponse   = Components.Schemas.ThreadStationsResponse
typealias NearestCityResponse      = Components.Schemas.NearestCityResponse
typealias CarrierResponse          = Components.Schemas.CarrierResponse
typealias AllStationsResponse      = Components.Schemas.AllStationsResponse

enum NetworkError: Error {
    case unexpectedContentType
    case emptyBody
}

enum ApiClientFactory {
    static func makeClient(baseURL: URL) -> Client {
        let transport = URLSessionTransport()
        return Client(serverURL: baseURL, transport: transport)
    }
}

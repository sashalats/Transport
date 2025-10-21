import OpenAPIURLSession
import OpenAPIRuntime
import Foundation
protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(
        apikey: String,
        code: String,
        system: String?,
        lang: String?,
        format: String?) async throws -> CarrierResponse
}

final class CarrierInfoService: CarrierInfoServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getCarrierInfo(
        apikey: String,
        code: String,
        system: String?,
        lang: String?,
        format: String?
    ) async throws -> CarrierResponse {
        let resp = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code,
            system: system,
            lang: lang,
            format: format
        ))
        return try resp.ok.body.json
    }
}

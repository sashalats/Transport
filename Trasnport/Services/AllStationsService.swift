import Foundation

protocol AllStationsServiceProtocol {
    func getAllStations(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> AllStationsResponse
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
    init(client: Client) { self.client = client }

    func getAllStations(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> AllStationsResponse {
        // Force JSON to avoid generator mapping to text/html; charset=utf-8
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/stations_list/")!
        var items: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apikey)
        ]
        if let lang, !lang.isEmpty { items.append(URLQueryItem(name: "lang", value: lang)) }
        // Prefer JSON explicitly to get a proper parsable payload
        let fmt = (format?.isEmpty == false) ? format! : "json"
        items.append(URLQueryItem(name: "format", value: fmt))
        components.queryItems = items

        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(AllStationsResponse.self, from: data)
        return decoded
    }
}

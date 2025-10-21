import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

protocol AllStationsRawServiceProtocol {
    func getAllStationsRaw(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> String
}

final class AllStationsRawService: AllStationsRawServiceProtocol {
    func getAllStationsRaw(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> String {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/stations_list/")!
        var items: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: apikey)
        ]
        if let lang, !lang.isEmpty {
            items.append(URLQueryItem(name: "lang", value: lang))
        }
        let fmt = (format?.isEmpty == false) ? format! : "json"
        items.append(URLQueryItem(name: "format", value: fmt))
        components.queryItems = items

        guard let url = components.url else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

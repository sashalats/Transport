import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Copyright API
protocol CopyrightServiceProtocol {
    func getCopyright(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> String
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    convenience init() {
        let baseURL = URL(string: "https://api.rasp.yandex.net")!
        let client = ApiClientFactory.makeClient(baseURL: baseURL)
        self.init(client: client)
    }

    func getCopyright(
        apikey: String,
        lang: String?,
        format: String?
    ) async throws -> String {
        var components = URLComponents(string: "https://api.rasp.yandex.net/v3.0/copyright/")!
        var items: [URLQueryItem] = [ URLQueryItem(name: "apikey", value: apikey) ]
        if let lang, !lang.isEmpty { items.append(URLQueryItem(name: "lang", value: lang)) }
        if let format, !format.isEmpty { items.append(URLQueryItem(name: "format", value: format)) }
        components.queryItems = items

        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let contentType = http.value(forHTTPHeaderField: "Content-Type")?.lowercased() ?? ""
        if contentType.contains("application/json") {
            struct CopyrightJSON: Decodable { let text: String? }
            if let decoded = try? JSONDecoder().decode(CopyrightJSON.self, from: data),
               let text = decoded.text {
                return text
            }
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
}

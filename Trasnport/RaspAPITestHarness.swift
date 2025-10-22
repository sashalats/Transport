import Foundation
import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Утилиты

private func isoDate(_ date: Date = .init()) -> String {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(secondsFromGMT: 0)
    f.dateFormat = "yyyy-MM-dd"
    return f.string(from: date)
}

private func makeClient() -> Client {
    let baseURL = URL(string: "https://api.rasp.yandex.net")!
    return Client(serverURL: baseURL, transport: URLSessionTransport())
}

// MARK: - Тест-харнесс

enum RaspAPITester {

    static func runAll(apikey: String,
                       threadUID: String? = nil, // укажите любой валидный uid нитки, если хотите проверить /thread
                       today: String = isoDate()) async -> String
    {
        var log: [String] = []
        let client = makeClient()

        // 1) nearest_stations
        do {
            let service = NearestStationsService(client: client)
            let res = try await service.getNearestStations(
                apikey: apikey,
                lat: 55.751244, lng: 37.618423,
                distance: 5,
                lang: "ru_RU",
                format: nil,
                stationTypes: nil,
                transportTypes: nil,
                offset: nil,
                limit: 10
            )
            log.append("✅ nearest_stations: stations=\(res.stations?.count ?? 0)")
        } catch {
            log.append("❌ nearest_stations: \(error)")
        }

        // 2) search (segments between stations)
        do {
            let service = SearchBetweenStationsService(client: client)
            let res = try await service.getSegments(
                apikey: apikey,
                from: "s9602490", // пример кода станции (замените при желании)
                to:   "s9600216", // пример кода станции (замените при желании)
                date: today,
                format: nil,
                lang: "ru_RU",
                transportTypes: nil,
                offset: nil,
                limit: 20,
                resultTimezone: nil,
                transfers: nil
            )
            let segCount = (res.segments?.count ?? 0) + (res.interval_segments?.count ?? 0)
            log.append("✅ search: segments=\(segCount)")
        } catch {
            log.append("❌ search: \(error)")
        }

        // 3) schedule (by station)
        do {
            let service = StationScheduleService(client: client)
            let res = try await service.getStationSchedule(
                apikey: apikey,
                station: "s9602490", // пример кода станции
                date: today,
                lang: "ru_RU",
                format: nil,
                transportTypes: nil,
                event: nil,
                direction: nil,
                system: nil,
                resultTimezone: nil
            )
            let cnt = (res.schedule?.count ?? 0) + (res.interval_schedule?.count ?? 0)
            log.append("✅ schedule: items=\(cnt)")
        } catch {
            log.append("❌ schedule: \(error)")
        }

        // 4) thread (route stations) — нужен валидный uid
        if let uid = threadUID, !uid.isEmpty {
            do {
                let service = ThreadRouteService(client: client)
                let res = try await service.getRouteStations(
                    apikey: apikey,
                    uid: uid,
                    from: nil, to: nil,
                    date: today,
                    showSystems: nil,
                    lang: "ru_RU",
                    format: nil
                )
                log.append("✅ thread: stops=\(res.stops?.count ?? 0), title=\(res.title ?? "-")")
            } catch {
                log.append("❌ thread: \(error)")
            }
        } else {
            log.append("⚠️ thread: пропущен (укажите threadUID для теста)")
        }

        // 5) nearest_settlement (nearest city)
        do {
            let service = NearestCityService(client: client)
            let res = try await service.getNearestCity(
                apikey: apikey, lat: 55.751244, lng: 37.618423,
                distance: 50, lang: "ru_RU", format: nil
            )
            log.append("✅ nearest_settlement: \(res.title ?? "-") [\(res.code ?? "-")]")
        } catch {
            log.append("❌ nearest_settlement: \(error)")
        }

        // 6) carrier
        do {
            let service = CarrierInfoService(client: client)
            let res = try await service.getCarrierInfo(
                apikey: apikey, code: "SU", system: "iata", lang: "ru_RU", format: nil
            )
            log.append("✅ carrier: carriers=\(res.carriers?.count ?? 0)")
        } catch {
            log.append("❌ carrier: \(error)")
        }

        // 7) stations_list (typed JSON)
        do {
            let service = AllStationsService(client: client)
            let res = try await service.getAllStations(
                apikey: apikey, lang: "ru_RU", format: "json"
            )
            log.append("✅ stations_list JSON: countries=\(res.countries?.count ?? 0)")
        } catch {
            log.append("❌ stations_list JSON: \(error)")
        }

        // 8) stations_list raw (string)
        do {
            let service = AllStationsRawService()
            let text = try await service.getAllStationsRaw(
                apikey: apikey, lang: "ru_RU", format: "json"
            )
            log.append("✅ stations_list RAW: length=\(text.count)")
        } catch {
            log.append("❌ stations_list RAW: \(error)")
        }

        // 9) copyright
        do {
            let service = CopyrightService()
            let text = try await service.getCopyright(apikey: apikey, lang: "ru_RU", format: nil)
            let preview = text.isEmpty ? "<empty>" : String(text.prefix(80)) + (text.count > 80 ? "…" : "")
            log.append("✅ copyright: \(preview)")
        } catch {
            log.append("❌ copyright: \(error)")
        }

        return log.joined(separator: "\n")
    }
}

// MARK: - SwiftUI тестовый экран (опционально)

struct APITestRunnerView: View {
    let apikey: String
    @State private var isRunning = false
    @State private var output = ""

    // при необходимости укажите реальный UID нитки:
    @State private var threadUID: String = ""

    var body: some View {
        VStack(spacing: 12) {
            Text("Yandex Rasp API — тесты")
                .font(.title3).bold()

            HStack {
                TextField("thread UID (опционально)", text: $threadUID)
                    .textFieldStyle(.roundedBorder)
                Button("Run API Tests") {
                    run()
                }
                .disabled(isRunning || apikey.isEmpty)
            }

            ScrollView {
                Text(output.isEmpty ? "Лог будет здесь…" : output)
                    .font(.system(.footnote, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        .padding()
    }

    private func run() {
        isRunning = true
        output = "⏳ Running…\n"
        Task {
            let log = await RaspAPITester.runAll(apikey: apikey, threadUID: threadUID)
            await MainActor.run {
                self.output = log
                self.isRunning = false
            }
        }
    }
}

//
//  TrasnportApp.swift
//  Trasnport
//
//  Auto-fixed entry point
//
import SwiftUI

//@main
//struct TrasnportApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
@main
struct TrasnportApp: App {
    init() {
        Task {
            let log = await RaspAPITester.runAll(apikey: "94826bdb-5cd5-47bf-b481-520ec7e60f3b")
            print(log)
        }
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

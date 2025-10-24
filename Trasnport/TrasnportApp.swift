import SwiftUI

@main
struct ScheduleTrackerApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

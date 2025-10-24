import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedCityFrom: String = ""
    @Published var selectedStationFrom: String = ""
    @Published var selectedCityTo: String = ""
    @Published var selectedStationTo: String = ""
    @Published var timeFilters: Set<TimePeriod> = []
    @Published var showTransfers: Bool? = nil
    
    var isFiltersValid: Bool {
        !timeFilters.isEmpty && showTransfers != nil
    }
}

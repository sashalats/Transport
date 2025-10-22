import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fromTofromTo = true
    @State private var showAgreement = false
    @ObservedObject var coordinator: NavigationCoordinator
    
    var body: some View {
        ZStack {
            Color("nightOrDayColor").ignoresSafeArea()
            VStack (spacing: 44){
                VStack(spacing: 16) {
                    ZStack {
                        Color("blueUniversal")
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                NavigationLink(value: EnumAppRoute.cityPicker(fromField: true)) {
                                    Text(fromTofromTo ? (coordinator.selectedCityFrom.isEmpty ? "Откуда" : "\(coordinator.selectedCityFrom) (\(coordinator.selectedStationFrom))")
                                         : (coordinator.selectedCityTo.isEmpty ? "Куда" : "\(coordinator.selectedCityTo) (\(coordinator.selectedStationTo))")
                                    )
                                    .foregroundStyle(
                                        (fromTofromTo
                                         ? coordinator.selectedCityFrom.isEmpty
                                         : coordinator.selectedCityTo.isEmpty
                                        )
                                        ? Color("grayUniversal")
                                        : Color("blackUniversal")
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                NavigationLink(value: EnumAppRoute.cityPicker(fromField: false)) {
                                    Text(fromTofromTo ? (coordinator.selectedCityTo.isEmpty ? "Куда" : "\(coordinator.selectedCityTo) (\(coordinator.selectedStationTo))")
                                         : (coordinator.selectedCityFrom.isEmpty ? "Откуда" : "\(coordinator.selectedCityFrom) (\(coordinator.selectedStationFrom))")
                                    )
                                    .foregroundStyle(
                                        (fromTofromTo
                                         ? coordinator.selectedCityTo.isEmpty
                                         : coordinator.selectedCityFrom.isEmpty
                                        )
                                        ? Color("grayUniversal")
                                        : Color("blackUniversal")
                                    )
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                            )
                            .padding(.horizontal, 16)
                            
                            Button(action: { fromTofromTo.toggle() }) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color("blueUniversal"))
                                    .padding(6)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(height: 128)
                    .padding(.horizontal, 16)
                    
                    if !coordinator.selectedCityTo.isEmpty && !coordinator.selectedCityFrom.isEmpty {
                        Button(action: {coordinator.path.append(EnumAppRoute.tickets)}) {
                            Text("Найти")
                                .font(.custom("SFPro-Bold", size: 17))
                                .foregroundStyle(Color(.white))
                        }
                        .padding(.horizontal, 47.5)
                        .padding(.vertical, 20)
                        .background(Color("blueUniversal"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                Spacer()
                
                Divider()
                    .frame(height: 3)
            }
            .padding(.top, 24)
        }
    }
}

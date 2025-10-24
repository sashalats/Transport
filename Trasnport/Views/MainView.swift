import SwiftUI

struct MainView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAgreement = false
    @ObservedObject var coordinator: NavigationCoordinator
    
    func swapDirection() {
        (coordinator.selectedCityFrom, coordinator.selectedCityTo) =
            (coordinator.selectedCityTo, coordinator.selectedCityFrom)
        (coordinator.selectedStationFrom, coordinator.selectedStationTo) =
            (coordinator.selectedStationTo, coordinator.selectedStationFrom)
    }
    
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
                                    Text(coordinator.selectedCityFrom.isEmpty
                                         ? "Откуда"
                                         : "\(coordinator.selectedCityFrom) (\(coordinator.selectedStationFrom))")
                                        .foregroundStyle(coordinator.selectedCityFrom.isEmpty
                                                         ? Color("grayUniversal") : Color("blackUniversal"))
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                NavigationLink(value: EnumAppRoute.cityPicker(fromField: false)) {
                                    Text(coordinator.selectedCityTo.isEmpty
                                         ? "Куда"
                                         : "\(coordinator.selectedCityTo) (\(coordinator.selectedStationTo))")
                                        .foregroundStyle(coordinator.selectedCityTo.isEmpty
                                                         ? Color("grayUniversal") : Color("blackUniversal"))
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
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    swapDirection()
                                }
                            })
                            {
                                Image("reverseIcon")
                                    .foregroundStyle(Color("blueUniversal"))
                                    .padding(6)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 16)
                        }
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

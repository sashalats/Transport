import SwiftUI


struct CarrierInfoView: View {
    @Environment(\.dismiss) var dismiss
    let carrier: TicketModel
    
    var body: some View {
        ZStack {
            Color("nightOrDayColor").ignoresSafeArea()
            VStack(spacing: 16) {
                Image(carrier.operatorLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 343, height: 104)
                    .padding(.top, 16)
                VStack(alignment: .leading, spacing: 16) {
                    Text(carrier.operatorName == "РЖД" ? "ОАО «РЖД»" : carrier.operatorName)
                        .font(.custom("SFPro-Bold", size: 24))
                        .foregroundStyle(Color("dayOrNightColor"))
                    VStack(alignment: .leading, spacing: 0) {
                        Text("E-mail")
                            .font(.custom("SFPro-Regular", size: 16))
                            .foregroundStyle(Color("dayOrNightColor"))
                            .padding(.top, 12)
                        if let mailURL = URL(string: "mailto:i.lozgkina@yandex.ru") {
                            Link("i.lozgkina@yandex.ru", destination: mailURL)
                                .font(.custom("SFPro-Regular", size: 16))
                                .foregroundColor(.blue)
                                .padding(.bottom, 12)
                        }
                        Text("Телефон")
                            .font(.custom("SFPro-Regular", size: 16))
                            .foregroundStyle(Color("dayOrNightColor"))
                            .padding(.top, 12)
                        Link("+7 (904) 329-27-71", destination: URL(string: "tel:+79043292771")!)
                            .font(.custom("SFPro-Regular", size: 16))
                            .foregroundColor(.blue)
                            .padding(.bottom, 12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image("leftChevron")
                            .renderingMode(.template)
                            .foregroundStyle(Color("dayOrNightColor"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Информация о перевозчике")
                        .font(.custom("SFPro-Bold", size: 17))
                        .foregroundStyle(Color("dayOrNightColor"))
                }
            }
        }
    }
}

#if DEBUG
struct CarrierInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierInfoView(
            carrier: TicketModel(
                operatorName: "РЖД",
                date: "21 декабря",
                departure: "11:30",
                arrival: "21:30",
                duration: "10 часов",
                withTransfer: true,
                operatorLogo: "RJDImage",
                note: "С пересадкой в Москве"
            )
        )
    }
}
#endif

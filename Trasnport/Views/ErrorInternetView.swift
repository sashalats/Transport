import SwiftUI

struct ErrorInternetView: View {
    var body: some View {
        ZStack {
            Color("nightOrDayColor").ignoresSafeArea()
            VStack (spacing: 16) {
                Image("errorInternetImage")
                Text("Нет интернета")
                    .font(.custom("SFPro-Bold", size: 24))
                    .foregroundStyle(Color("dayOrNightColor"))
            }
        }
    }
}

#Preview {
    ErrorInternetView()
}

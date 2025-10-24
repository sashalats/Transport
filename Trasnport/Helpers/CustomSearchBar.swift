import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Введите запрос"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.grayUniversal)
            
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.grayUniversal)
                }
            }
        }
        .padding(10)
        .background(Color(.backgroundSearchbar))
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

import SwiftUI

struct CustomTextField: View {
    
    let imageName: String
    let placeholderText: String
    var isSecureField: Bool? = false
    
    @Binding var text: String
    @State private var securePassword = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(.darkGray))
            if securePassword {
                SecureField(placeholderText, text: $text)
            } else {
                TextField(placeholderText, text: $text)
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(.gray)
        }
        .overlay(alignment: .trailing) {
            if text != "" && isSecureField ?? false {
                Image(systemName: securePassword ? "eye.slash" : "eye")
                    .padding(.trailing)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        securePassword.toggle()
                    }
            }
        }
        .onAppear {
            securePassword = isSecureField ?? false
        }
    }
}
    

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(imageName: "envelope",
                        placeholderText: "Email",
                        isSecureField: true,
                        text: .constant("e"))
    }
}

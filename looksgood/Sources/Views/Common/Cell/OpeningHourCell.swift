import SwiftUI

struct OpeningHourCell: View {
    
    @State private var hour = ""
    @State private var minutes = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("H", text: $hour)
                    .background(Color.background)
                    .frame(width: 30, height: 40)
                    .padding()
                    .keyboardType(.numberPad)
                Text(":")
                    .foregroundColor(.blackWhite)
                TextField("M", text: $minutes)
                    .background(Color.background)
                    .frame(width: 30, height: 40)
                    .padding()
                    .keyboardType(.numberPad)
            }
        }
        .frame(width: 150)
        .background(Color.background)
        .cornerRadius(20)
    }
}

struct OpeningHourCell_Previews: PreviewProvider {
    static var previews: some View {
        OpeningHourCell()
    }
}

import SwiftUI

struct SettingsCell: View {

    var image: String
    var title: String

        var body: some View {
            VStack {
                HStack {
                    Image(systemName: image)
                    Text(title)
                    Spacer()
                }
                .frame(height: 50)
                .padding(.horizontal)
                Divider()
            }
            .foregroundColor(.blackWhite)
            .contentShape(Rectangle())
        }
    }


struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(image: "gear", title: "Settings")
    }
}

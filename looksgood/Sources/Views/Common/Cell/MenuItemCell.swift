import SwiftUI
struct MenuItemCell: View {
    
    var menuItem: MenuItem

    var body: some View {
        HStack(alignment: .top) {
            if let imageURL = menuItem.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .frame(width: 130, height: 130)
                        .scaledToFit()
                        .clipped()
                } placeholder: {
                    Image(systemName: "fork.knife")
                        .resizable()
                        .frame(width: 130, height: 130)
                        .foregroundColor(.gray)
                }
            }
            VStack(alignment: .leading) {
                Text(menuItem.title)
                    .font(.title2).bold()
                Text(menuItem.description ?? "")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .frame(height: 130)
        .overlay(alignment: .bottomTrailing) {
            Text(menuItem.price)
                .font(.title2.bold())
                .padding()
        }
        .contentShape(Rectangle())
    }
}

struct MenuItemCell_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemCell(menuItem: MenuItem(placeID: "",
                                        title: "Chease burger",
                                        price: "25 zl",
                                        category: .Alcohol,
                                        description: "Pszyny cheesee mmm oj tak rozplywa sie w ustach"))
    }
}

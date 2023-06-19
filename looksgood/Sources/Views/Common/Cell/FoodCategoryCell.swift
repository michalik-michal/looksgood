import SwiftUI

struct FoodCategoryCell: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.callout)
            .foregroundColor(.blackWhite)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blackWhite, lineWidth: 1)
                    .padding(1)
            }
    }
}

struct FoodCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        FoodCategoryCell(title: "Burger")
    }
}

import SwiftUI

struct DeleteSubCategorySheet: View {
    
    var category: PlaceCategoriesEnum
    @Binding var showSheet: Bool
    @EnvironmentObject private var placeService: PlaceService
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(Strings.delete)
                    .bold()
                    .onTapGesture {
                        Task {
                            try await placeService.deleteSubSategory(category)
                            showSheet = false
                        }
                    }
            }
            .padding(.horizontal)
            PlaceCategoryCell(placeCategory: PlaceCategory(type: category))
        }
        .presentationDetents([.height(100)])
    }
}

struct DeleteSubCategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSubCategorySheet(category: .restaurant,
                               showSheet: .constant(false))
    }
}

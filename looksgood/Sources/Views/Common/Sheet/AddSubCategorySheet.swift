import SwiftUI

struct AddSubCategorySheet: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @Binding var showSheet: Bool
    @State private var selectedSubCategory: PlaceCategoriesEnum?
    
    var body: some View {
        VStack() {
            HStack {
                Text(Strings.subCategory)
                    .font(.title2)
                Spacer()
            }
            PlaceCategoryPicker(selectedCategory: $selectedSubCategory)
                .padding(.bottom)
            PlainButton(title: Strings.upload) {
                Task {
                    if let selectedCategory = selectedSubCategory {
                        try await placeService.uploadSubCategory(selectedCategory)
                        showSheet = false
                    }
                }
            }
            .frame(width: 300)
        }
        .padding(.horizontal)
    }
}

struct AddSubCategorySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddSubCategorySheet(showSheet: .constant(false))
    }
}

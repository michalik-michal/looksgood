import SwiftUI
import PhotosUI

struct AddMenuItemSheet: View {
     
    @EnvironmentObject private var service: PlaceService
    @Binding var isShowing: Bool
    @State private var showCategoryStack = false
    @State private var selectedCurrency: Currency = .ZŁ
    @State private var selectedCategory: FoodCategory?
    @State private var ingredients: [String]  = []
    @State private var menuItem = MenuItem(placeID: "",
                                           title: "",
                                           price: "",
                                           category: .All,
                                           description: "")
    
    var body: some View {
        VStack {
            addImage()
            CustomTextField(imageName: "fork.knife", placeholderText: "Name", text: $menuItem.title)
            HStack {
                CustomTextField(imageName: "dollarsign", placeholderText: "Price", text: $menuItem.price)
                    .keyboardType(.numberPad)
                currencyMenu
            }
            CustomTextField(imageName: "pencil", placeholderText: "Description (optional)", text: $menuItem.description.safe(""))
            selectedCategoriesStack
            addCategoryStack
            Spacer()
            PlainButton(title: Strings.done) {
                Task {
                    menuItem.price = "\(menuItem.price) \(selectedCurrency.rawValue)"
                    menuItem.category = selectedCategory ?? .All
                    try await menuItem.imageURL = service.uploadPhoto()
                    try await service.uploadMenuItem(menuItem: menuItem)
                    isShowing = false
                }
            }
            .bold()
        }
        .foregroundColor(.blackWhite)
        .padding()
        .onDisappear {
            service.selectedMenuImage = nil
        }
    }

    private func addImage() -> some View {
        PhotosPicker(selection: $service.selectedMenuImage,
                     matching: .any(of: [.images,
                                         .screenshots,
                                         .not(.videos)])) {
                                             if service.selectedMenuImage == nil {
                                                 VStack {
                                                     Image(systemName: "plus")
                                                         .resizable()
                                                         .frame(width: 25, height: 25)
                                                     Text("Add Image")
                                                 }
                                                 .foregroundColor(.blackWhite)
                                                 .frame(maxWidth: .infinity)
                                                 .frame(height: 180)
                                                 .background(Color(.systemGray6))
                                                 .cornerRadius(12)
                                             } else {
                                                 switch service.imageState {
                                                 case .success(let image):
                                                     image
                                                         .resizable()
                                                         .aspectRatio(contentMode: .fill)
                                                         .frame(height: 180)
                                                         .clipped()
                                                         .cornerRadius(12)
                                                 default:
                                                     Text("Unable to preview photo")
                                                         .foregroundColor(.blackWhite)
                                                         .frame(maxWidth: .infinity)
                                                         .frame(height: 180)
                                                         .background(Color(.systemGray6))
                                                         .cornerRadius(12)
                                                 }
                                             }
                                         }
    }

    private var currencyMenu: some View {
        Menu {
            ForEach(Currency.allCases, id: \.self) { currency in
                Button {
                    selectedCurrency = currency
                } label: {
                    Text(currency.rawValue)
                }
            }
        } label: {
            Text(selectedCurrency.rawValue)
                .frame(width: 50, height: 50)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                }
        }
    }
    
    private var selectedCategoriesStack: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if selectedCategory == nil {
                    HStack {
                        Text("Select category")
                        SystemImage(.plus)
                            .frame(width: 15, height: 15)
                    }
                    .onTapGesture {
                        showCategoryStack.toggle()
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blackWhite, lineWidth: 1)
                            .padding(1)
                    }
                } else {
                    FoodCategoryCell(title: selectedCategory?.rawValue ?? "")
                        .onTapGesture {
                            showCategoryStack.toggle()
                        }
                }
            }
        }
    }
    
    private var addCategoryStack: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FoodCategory.allCases, id: \.self) { category in
                        FoodCategoryCell(title: category.rawValue)
                            .onTapGesture {
                                selectedCategory = category
                                showCategoryStack = false
                            }
                    }
                }
            }
            .hide(if: !showCategoryStack)
        }
    }
}

struct AddMenuItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemSheet(isShowing: .constant(true))
            .environmentObject(PlaceService())
    }
}

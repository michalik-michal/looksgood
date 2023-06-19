import SwiftUI
import PhotosUI

struct AddMenuItemSheet: View {
     
    @EnvironmentObject private var service: PlaceService
    @Binding var isShowing: Bool
    @State private var showCategoryStack = false
    @State private var selectedCurrency: Currency = .ZŁ
    @State private var selectedCategories: [String] = []
    @State private var selectedCategoryToAdd: FoodCategory?
    @State private var ingredients: [String]  = []
    @State private var menuItem = MenuItem(placeID: "",
                                           title: "",
                                           price: "",
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
                    try await menuItem.image = service.uploadPhoto()
                    try await service.uploadMenuItem(menuItem: menuItem)
                    isShowing = false
                }
            }
            .bold()
        }
        .foregroundColor(.blackWhite)
        .padding()
    }

    private func addImage() -> some View {
        PhotosPicker(selection: $service.selectedItem,
                     matching: .any(of: [.images,
                                         .screenshots,
                                         .not(.videos)])) {
                                             if service.selectedItem == nil {
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
                                                 Text("Photo added")
                                                     .foregroundColor(.blackWhite)
                                                     .frame(maxWidth: .infinity)
                                                     .frame(height: 180)
                                                     .background(Color(.systemGray6))
                                                     .cornerRadius(12)
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
                if selectedCategories.isEmpty {
                    HStack {
                        Text("Add category")
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
                    ForEach(selectedCategories, id: \.self) { title in
                        FoodCategoryCell(title: title)
                    }
                    SystemImage(.plus)
                        .frame(width: 15, height: 15)
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
                            .bold(category == selectedCategoryToAdd)
                            .onTapGesture {
                                selectedCategoryToAdd = category
                            }
                    }
                }
            }
            .hide(if: !showCategoryStack)
            HStack {
                Text("Add")
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blackWhite, lineWidth: 1)
                    }
                Spacer()
            }
            .hide(if: selectedCategoryToAdd == nil)
            .onTapGesture {
                selectedCategories.append(selectedCategoryToAdd?.rawValue ?? "")
                selectedCategoryToAdd = nil
                showCategoryStack = false
            }
        }
    }
}

struct AddMenuItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddMenuItemSheet(isShowing: .constant(true))
    }
}

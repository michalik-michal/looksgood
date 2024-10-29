import SwiftUI

struct MenuView: View {
    
    var placeID: String
    @State private var selectedDate: Date?
    @State private var selectedTimeSlot: String? // Track the selected time slot
    let todayDate = Date()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                // Define an array of time slots for each day
                let timeSlots = [
                    ["14:00 - 16:00", "15:00 - 17:00"],
                    ["10:00 - 12:00"],
                    ["12:00 - 14:00", "19:00 - 21:00"]
                ]
                let miejsca = [
                    ["9", "12"],
                    ["5"],
                    ["3", "15"]
                ]
                
                // Iterate over timeSlots and increment the date for each section
                ForEach(0..<timeSlots.count, id: \.self) { index in
                    // Calculate the date for each section
                    let date = Calendar.current.date(byAdding: .day, value: index, to: todayDate)!
                    
                    // Display the date label in Polish
                    Text(formattedDate(date))
                        .font(.headline)
                        .padding(.vertical, 10)
                    
                    // Display the HStack with time slots for the current date
                    VStack(spacing: 5) {
                        ForEach(Array(zip(timeSlots[index], miejsca[index])), id: \.0) { timeSlot in
                            timeSlotCell(timeSlot.0, number: timeSlot.1)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func timeSlotCell(_ time: String, number: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(time)
                    .font(.title3)
                    .bold()
                Text("\(number) miejsc")
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .cornerRadius(12)
        .onTapGesture {
            selectedTimeSlot = time
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedTimeSlot == time ? Color.black : Color.clear, lineWidth: 1)
        )
    }

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(placeID: "")
    }
}
    
    // Helper function to format date in Polish
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }


    //     VStack {
 //            if menuCategories.isNotEmpty, menuItems.isNotEmpty {
 //                MenuItemCategoryStack(menuItemsCategories: menuCategories,
 //                                      selectedCategory: $selectedCategory.safe(.All))
 //                TabView(selection: $selectedCategory.safe(.All)) {
 //                    ForEach(menuCategories, id: \.rawValue) { category in
 //                        ScrollView(showsIndicators: false) {
 //                            VStack(spacing: 0) {
 //                                ForEach(menuItems, id: \.title) { item in
 //                                    NavigationLink {
 //                                        MenuItemDetailsView(menuItem: item, ownerView: false)
 //                                            .backNavigationButton()
 //                                    } label: {
 //                                        if category == .All {
 //                                            MenuItemCell(menuItem: item)
 //                                        } else if item.category == category {
 //                                            MenuItemCell(menuItem: item)
 //                                        }
 //                                    }
 //                                    .buttonStyle(FullOpacity())
 //                                }
 //                            }
 //                        }
 //                        .tag(category)
 //                    }
 //                }
 //                .frame(height: UIScreen.main.bounds.height - 250)
 //                .tabViewStyle(.page(indexDisplayMode: .never))
 //            }
         }
 //        .onAppear {
 //            Task {
 //                menuItems = try await placeService.fetchMenuItems(with: placeID) ?? []
 //                menuCategories = placeService.retreiveCategories(for: menuItems)
 //            }
 //        }
   //  }

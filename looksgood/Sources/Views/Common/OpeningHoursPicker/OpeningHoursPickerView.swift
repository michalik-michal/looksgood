import SwiftUI

struct OpeningHoursPickerView: View {
    
    @State private var selectedDay = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Opening Hours")
                .font(.title).bold()
            TabView(selection: $selectedDay) {
                ForEach(Strings.weekDays, id: \.self) { weekDay in
                    DayOpeningCell(weekDay: weekDay)
                        .tag(weekDay)
                }
            }
            .padding(.top, -30)
            .tabViewStyle(.page)
            .frame(height: 180)
        }
    }
}

struct OpeningHoursView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningHoursPickerView()
    }
}

import SwiftUI

struct OpeningHoursView: View {
    
    var openingHours: [String]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(openingHours, id: \.self) { day in
                    HStack {
                        Text("•")
                            .font(.title)
                        Text(day)
                    }
                    .font(.title3)
                }
            }
            .padding()
        }
    }
}

struct OpeningHoursView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningHoursView(openingHours: [
            "Monday: 9:00 AM – 4:00 PM",
            "Tuesday: 9:00 AM – 4:00 PM",
            "Wednesday: 9:00 AM – 4:00 PM",
            "Thursday: 9:00 AM – 8:00 PM",
            "Friday: 9:00 AM – 8:00 PM",
            "Saturday: 9:00 AM – 8:00 PM",
            "Sunday: 9:00 AM – 8:00 PM"
        ])
    }
}

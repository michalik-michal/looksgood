import SwiftUI

struct DayOpeningCell: View {
    
    var weekDay: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(weekDay)
                .font(.title2)
            HStack() {
                    OpeningHourCell()
                Text("-")
                    OpeningHourCell()
            }
        }
    }
}

struct DayOpeningCell_Previews: PreviewProvider {
    static var previews: some View {
        DayOpeningCell(weekDay: "Monday")
    }
}

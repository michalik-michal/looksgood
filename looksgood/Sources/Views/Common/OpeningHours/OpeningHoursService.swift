import Foundation

class OpeningHoursService: ObservableObject {
    
    func isDayToday(day: String) -> Bool {
        let weekDay = day.components(separatedBy: ":").first
        let todaysDate = DateHelper().getTodaysDay()
        return weekDay == todaysDate
    }
    
}

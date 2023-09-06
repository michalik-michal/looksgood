import Foundation

class DateHelper {
    func getTodaysDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    /// Convert opening hours from format: "Monday: 9:00 AM – 4:00 PM" to "9:00 AM – 4:00 PM"
    private func getOpeningHour(date: String) -> String {
        let openingHours = date.components(separatedBy: " ")[1]
        return openingHours
    }
    
    /// Get todays opening hours to format "9:00 AM – 4:00 PM"
    func getTodaysOpeningHours(for openingHours: [String]) -> String {
        var todayOpeningHours = ""
        for day in openingHours {
            let weekDay = day.components(separatedBy: ":").first
            let todaysDate = DateHelper().getTodaysDay()
            if weekDay == todaysDate {
                todayOpeningHours =  day
            }
        }
        todayOpeningHours = getOpeningHour(date: todayOpeningHours)
        return todayOpeningHours
    }
}

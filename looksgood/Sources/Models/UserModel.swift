import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var username: String
    var accountType: AccountType
    var places: String?
}

struct Kid: Codable {
    var imie: String
    var image: String
    var wiek: String
    var zainteresowania: [String]
    var info: String
}

struct Reservation: Codable {
    var timeslot: String
    var place: String
    var date: Date
}

func saveReservation(_ reservation: Reservation) {
    var reservations = loadAllReservations() // Load current reservations
    reservations.append(reservation) // Add the new reservation
    if let encoded = try? JSONEncoder().encode(reservations) {
        UserDefaults.standard.set(encoded, forKey: "savedReservations") // Save the updated array
    }
}

func loadAllReservations() -> [Reservation] {
    if let savedData = UserDefaults.standard.data(forKey: "savedReservations"),
       let decoded = try? JSONDecoder().decode([Reservation].self, from: savedData) {
        return decoded
    }
    return [] // Return an empty array if no data is found
}

func deleteReservation(_ reservation: Reservation) {
    var reservations = loadAllReservations()
    
    // Find and remove the reservation (assuming Reservation conforms to Equatable for this example)
    if let index = reservations.firstIndex(where: { $0.timeslot == reservation.timeslot && $0.place == reservation.place && $0.date == reservation.date }) {
        reservations.remove(at: index)
        
        // Save the updated reservations list
        if let encoded = try? JSONEncoder().encode(reservations) {
            UserDefaults.standard.set(encoded, forKey: "savedReservations")
        }
    }
}

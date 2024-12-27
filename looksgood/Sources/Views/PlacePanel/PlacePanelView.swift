import SwiftUI

struct PlacePanelView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @State private var reservations: [Reservation] = []
    @State private var selectedReservation: Reservation?
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            if reservations.isEmpty {
                ContentUnavailableView {
                    Label("Nie masz jeszcze rezerwacji", systemImage: "calendar")
                } description: {
                    Text("Czas to zmienić!")
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Moje Zajęcia")
                                .font(.title.bold())
                            Spacer()
                        }
                        .padding()
                        ForEach(reservations, id: \.place) { reservation in
                            reservationCell(reservation)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            reservations = loadAllReservations()
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Napewno?"),
                message: Text("Ta rezerwacja będzie odwołana bezpowrotnie"),
                primaryButton: .destructive(Text("Odwołaj")) {
                    if let selectedReservation {
                        deleteReservation(selectedReservation)
                        reservations = loadAllReservations()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
    // Helper function to format date in Polish
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func reservationCell(_ reservation: Reservation) -> some View{
        VStack(spacing: 5) {
            HStack {
                Spacer()
                Text("Odwołaj")
                    .foregroundStyle(.orange)
                    .onTapGesture {
                        selectedReservation = reservation
                        showDeleteAlert = true
                    }
            }
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(formattedDate(reservation.date))")
                        Spacer()
                        Text("\(reservation.timeslot)")
                    }
                    .bold()
                    Text("\(reservation.place)")
                        .font(.title2)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .cornerRadius(20)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
    
}

struct PlacePanelView_Previews: PreviewProvider {
    static var previews: some View {
        PlacePanelView()
    }
}

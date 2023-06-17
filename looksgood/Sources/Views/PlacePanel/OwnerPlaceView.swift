import SwiftUI

struct OwnerPlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @State private var showCategorySheet = false
    
    var body: some View {
         ScrollView(showsIndicators: false) {
             VStack(alignment: .leading) {
                 if let place = placeService.usersPlace {
                     if false {
                         ImageView(image: "restaurant", height: 180)
                     } else {
                         addImages
                     }
                     VStack {
                         VStack {
                             titleStack
                             adressStack
                             secondaryStack
                             VStack(spacing: 10) {
                                 PlainLabel(title: place.phoneNumber ?? "Add phone number",
                                            alignment: .leading,
                                            image: Image(systemName: "phone"))
                                 PlainLabel(title: place.website ?? "Add website",
                                            alignment: .leading,
                                            image: Image(systemName: "globe"))
                             }
                         }
                         .padding(.horizontal)
                         Spacer()
                     }
                 }
             }
         }
         .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
                 Button("Edit") {
                     print("")
                 }
             }
         }
     }
    
    private var addImages: some View {
        VStack {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 25, height: 25)
            Text(Strings.addImages)
        }
        .foregroundColor(.blackWhite)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color(.systemGray6))
    }
     
     private var titleStack: some View {
         HStack {
             Text(placeService.usersPlace?.name ?? "")
                 .font(.title.bold())
                 .foregroundColor(.black)
             Spacer()
             if let rating = placeService.usersPlace?.rating {
                 HStack {
                     Image(systemName: "star.fill")
                         .resizable()
                         .foregroundColor(.yellow)
                         .frame(width: 15, height: 15)
                     Text(rating)
                         .foregroundColor(.gray)
                         .bold()
                     Text("(149)")
                         .foregroundColor(.gray)
                     Image("google")
                         .resizable()
                         .frame(width: 30, height: 30)
                 }
                 .padding(.top, 3)
                 .onTapGesture {
                     let link = "https://goo.gl/maps/bJMtrxCDRBzPYjPH7"
                     UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                 }
             }
             
         }
     }
     
     private var adressStack: some View {
         HStack {
             Text(placeService.usersPlace?.address ?? "Add address")
                 .foregroundColor(.gray)
             Spacer()
             Text("10:00 - 23:00")
                 .foregroundColor(.gray)
                 .bold()
         }
     }
     
     private var secondaryStack: some View {
         HStack {
             PlaceCategoryCell(placeCategory: PlaceCategory(category: "Restaurant",
                                                            image: "house",
                                                            type: .restaurant))
             .onTapGesture {
                 showCategorySheet.toggle()
             }
             Spacer()
         }
         .padding(.bottom)
     }
     
     private func navigateOnGoogleMap(sourceLatitude : Double, sourceLongitude : Double, destinationLatitude : Double, destinationLongitude : Double) {
             let urlGoogleMap : URL = URL(string: "comgooglemaps://?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")!
             
             if UIApplication.shared.canOpenURL(urlGoogleMap) {
                 UIApplication.shared.open(urlGoogleMap, options: [:], completionHandler: nil)
                 
             } else {
                 let urlString = URL(string:"http://maps.google.com/?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")
                 
                 UIApplication.shared.open(urlString!, options: [:], completionHandler: nil)
             }
         }
 }


struct OwnerPlaceView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        OwnerPlaceView()
            .environmentObject( { () -> PlaceService in
                let object = PlaceService()
                object.usersPlace = Place(name: "Portobello",
                                          address: "Ul. Pod Wawelem 3b",
                                          rating: "4.2",
                                          phoneNumber: "123 456 789",
                                          website: "www.apple.com",
                                          placeCategory: .restaurant)
                return object
            }())
    }
}

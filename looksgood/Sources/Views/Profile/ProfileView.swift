import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var placeService: PlaceService
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if let user = authService.currentUser {
            if authService.userSession != nil {
                VStack(alignment: .leading) {
                    Text("Moje Konto")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                        .foregroundColor(.blackWhite)
                    Divider()
                    ScrollView {
                        HStack(alignment: .top) {
                            asyncImage(url: placeService.kid1?.image ?? "")
                            VStack(alignment: .leading) {
                                Text("\(placeService.kid1?.imie ?? "Tomek"), \(placeService.kid1?.wiek ?? "6") lat ")
                                    .font(.title)
                                    .bold()
                                    .padding(.top)
                                HStack {
                                    Text(placeService.kid1?.zainteresowania[0] ?? "")
                                        .padding(7)
                                        .background(.gray.opacity(0.1), in: Capsule())
                                        .font(.caption)
                                    Text(placeService.kid1?.zainteresowania[1] ?? "")
                                        .padding(7)
                                        .background(.gray.opacity(0.1), in: Capsule())
                                        .font(.caption)
                                    Spacer()
                                }
                                HStack {
                                    Text(placeService.kid1?.zainteresowania[2] ?? "")
                                        .padding(7)
                                        .background(.gray.opacity(0.1), in: Capsule())
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        Divider()
                            .padding(.horizontal)
                        HStack {
                            Text("Dodatkowe Informacje:")
                                .font(.title2)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        Text(placeService.kid1?.info ?? "")
                            .padding(.horizontal)
                            .foregroundStyle(.gray)

//                        NavigationLink {
//                            AccountSettingsView()
//                        } label: {
//                            SettingsCell(image: "gearshape", title: Strings.accountSettings)
//                        }
//                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .onAppear {
                    Task {
                        try? await placeService.fetchKid1()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            AccountSettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        
                    }
                }
            }
        } else {
            LoginView()
        }
    }

    private func asyncImage(url: String) -> some View {
        return AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(30)
                .padding()
               // .clipped()
        } placeholder: {
            ProgressView()
                .frame(width: 120,
                       height: 200)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

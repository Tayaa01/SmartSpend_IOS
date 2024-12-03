import SwiftUI

struct settingsView: View {
    @State private var showingLogoutAlert = false // Pour afficher l'alerte
    @State private var isLoggedOut = false // Pour déclencher la navigation vers la page de connexion
    
    var body: some View {
        VStack {
            if isLoggedOut {
                // Afficher la page de connexion après la déconnexion
                SignInView() // Remplacez ceci par votre vue de connexion réelle
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Section Profil
                        SettingsSection(title: "Profile", items: [
                            SettingsItem(title: "My Profile", icon: "pencil", action: {}),
                            SettingsItem(title: "Change Password", icon: "lock", action: {}),
                            SettingsItem(title: "Log out", icon: "arrow.right.circle", action: {
                                showingLogoutAlert = true // Affiche l'alerte lorsque l'utilisateur clique sur "Log out"
                            })
                        ])
                        
                        // Section Notifications
                        // ...
                        
                        // Section Security
                        // ...
                        
                        // Section About
                        SettingsSection(title: "About", items: [
                            SettingsItem(title: "Version", icon: "app.fill", action: {}),
                            SettingsItem(title: "Privacy Policy", icon: "doc.plaintext", action: {}),
                            SettingsItem(title: "Terms of Service", icon: "doc.text", action: {}),
                            SettingsItem(title: "Contact Us", icon: "phone.fill", action: {})
                        ])
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Settings")
                .alert(isPresented: $showingLogoutAlert) {
                    Alert(
                        title: Text("Are you sure you want to log out?"),
                        message: Text("You will be redirected to the login page."),
                        primaryButton: .destructive(Text("Log out")) {
                            logout()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    private func logout() {
        // Vous pouvez effacer les données de session ou le token ici si nécessaire
        // Par exemple : UserDefaults.standard.removeObject(forKey: "access_token")
        
        // Redirigez l'utilisateur vers la page de connexion
        isLoggedOut = true
    }
}

struct SettingsSection: View {
    var title: String
    var items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .padding(.bottom, 5)
            
            ForEach(items, id: \.title) { item in
                item
            }
        }
    }
}

struct SettingsItem: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login Page") // Remplacez par votre propre vue de connexion
        }
        .navigationTitle("Login")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

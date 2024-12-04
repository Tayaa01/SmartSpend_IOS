import SwiftUI

struct settingsView: View {
    @State private var showingLogoutAlert = false // Pour afficher l'alerte
    @State private var isLoggedOut = false // Pour déclencher la navigation vers la page de connexion
    @State private var showVersionView = false // Pour contrôler la navigation vers la vue de version
    @State private var showPrivacyPolicyView = false // Pour contrôler la navigation vers la vue de politique de confidentialité
    @State private var showTermsOfServiceView = false // Pour contrôler la navigation vers la vue des termes d'utilisation
    @State private var showContactUsView = false // Pour contrôler la navigation vers la vue Contact Us
    
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
                        
                        // Section About
                        SettingsSection(title: "About", items: [
                            SettingsItem(title: "Version", icon: "app.fill", action: {
                                showVersionView = true // Afficher la vue de version
                            }),
                            SettingsItem(title: "Privacy Policy", icon: "doc.plaintext", action: {
                                showPrivacyPolicyView = true // Afficher la vue de politique de confidentialité
                            }),
                            SettingsItem(title: "Terms of Service", icon: "doc.text", action: {
                                showTermsOfServiceView = true // Afficher la vue des conditions d'utilisation
                            }),
                            SettingsItem(title: "Contact Us", icon: "phone.fill", action: {
                                showContactUsView = true // Afficher la vue Contact Us
                            })
                        ])
                        
                        Spacer()
                    }
                    .padding()
                    .background(
                        NavigationLink(destination: VersionView(), isActive: $showVersionView) { EmptyView() }
                    )
                    .background(
                        NavigationLink(destination: PrivacyPolicyView(), isActive: $showPrivacyPolicyView) { EmptyView() }
                    )
                    .background(
                        NavigationLink(destination: TermsOfServiceView(), isActive: $showTermsOfServiceView) { EmptyView() }
                    )
                    .background(
                        NavigationLink(destination: ContactUsView(), isActive: $showContactUsView) { EmptyView() } // Navigation vers Contact Us
                    )
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

// Vue de la version
struct VersionView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Titre
            Text("App Version")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding(.top, 20)
            
            // Informations sur la version et le build
            VStack(alignment: .leading, spacing: 10) {
                Text("Version : \(getAppVersion())")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Text("Build : \(getAppBuild())")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.vertical, 20)
            
            // Informations supplémentaires
            VStack(alignment: .leading, spacing: 10) {
                Text("About This App")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                Text("This app is designed to help you manage your finances and make smarter spending decisions. The app provides personalized recommendations based on your financial habits.")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text("Developed by: SmartSpend Team")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text("Contact us at: support@smartspend.com")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Version Info")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    // Fonction pour récupérer la version de l'application
    func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    // Fonction pour récupérer le build de l'application
    func getAppBuild() -> String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Unknown"
    }
}

// Vue de la politique de confidentialité
struct PrivacyPolicyView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Titre
            Text("Privacy Policy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding(.top, 20)
            
            // Politique de confidentialité
            VStack(alignment: .leading, spacing: 10) {
                Text("1. Introduction")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("This Privacy Policy explains how we collect, use, and protect your personal information when you use our mobile app. By using our app, you agree to the terms of this policy.")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text("2. Information We Collect")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We collect the following types of personal data: Name, email address, location data, usage data.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("3. How We Use Your Information")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We use the information we collect to provide and improve our services, communicate with you, and personalize your experience.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("4. Data Security")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We implement appropriate security measures to protect your data. However, no method of transmission over the internet is completely secure.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("5. Contact Us")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("If you have any questions about this Privacy Policy, please contact us at support@smartspend.com.")
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// Vue des termes d'utilisation
struct TermsOfServiceView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Titre
            Text("Terms of Service")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding(.top, 20)
            
            // Conditions d'utilisation
            VStack(alignment: .leading, spacing: 10) {
                Text("1. Introduction")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("These Terms of Service govern your use of our mobile application. By using our app, you agree to these terms.")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text("2. Use of the App")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("You may use our app only for lawful purposes and in accordance with these Terms of Service.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("3. Limitation of Liability")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We are not liable for any direct or indirect damages arising from the use of the app.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("4. Termination")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("We may suspend or terminate your access to the app if you violate these terms.")
                    .font(.body)
                    .foregroundColor(.black)
                
                Text("5. Contact Us")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("For any questions or concerns, please contact us at support@smartspend.com.")
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// Vue Contact Us
struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Titre
            Text("Contact Us")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding(.top, 20)
            
            // Informations de contact
            VStack(alignment: .leading, spacing: 10) {
                Text("If you have any questions or need assistance, feel free to contact us through the following methods:")
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Text("Email: support@smartspend.com")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Phone: +1 (555) 123-4567")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Follow us on social media for updates:")
                    .font(.body)
                    .foregroundColor(.black)
                
                HStack {
                    Image("logo.facebook") // Remplacez "facebook_logo" par le nom de l'image dans vos assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Image("logo.twitter") // Remplacez "twitter_logo" par le nom de l'image dans vos assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Image("logo.instagram") // Remplacez "instagram_logo" par le nom de l'image dans vos assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }

            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

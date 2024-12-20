import SwiftUI

// Vue principale
struct settingsView: View {
    @State private var showingLogoutAlert = false
    @State private var isLoggedOut = false
    @State private var showVersionView = false
    @State private var showPrivacyPolicyView = false
    @State private var showTermsOfServiceView = false
    @State private var showContactUsView = false
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedOut {
                    SignInView() // Remplacez par votre propre vue de connexion
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Section Profil
                            SettingsSection(title: "Profile", items: [
                                SettingsItem(title: "My Profile", icon: "person.fill", action: {}),
                                SettingsItem(title: "Change Password", icon: "key.fill", action: {}),
                                SettingsItem(title: "Log out", icon: "arrow.right.circle.fill", action: {
                                    showingLogoutAlert = true
                                })
                            ])
                            
                            // Section About
                            SettingsSection(title: "About", items: [
                                SettingsItem(title: "Version", icon: "info.circle.fill", action: {
                                    showVersionView = true
                                }),
                                SettingsItem(title: "Privacy Policy", icon: "lock.shield.fill", action: {
                                    showPrivacyPolicyView = true
                                }),
                                SettingsItem(title: "Terms of Service", icon: "doc.text.fill", action: {
                                    showTermsOfServiceView = true
                                }),
                                SettingsItem(title: "Contact Us", icon: "envelope.fill", action: {
                                    showContactUsView = true
                                })
                            ])
                            
                            // Section Currency
                            SettingsSection(title: "Currency", items: [
                                SettingsItem(title: "Select Currency", icon: "dollarsign.circle.fill", action: {})
                            ])
                            
                            // Currency Picker
                            currencyPicker()
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
                            NavigationLink(destination: ContactUsView(), isActive: $showContactUsView) { EmptyView() }
                        )
                    }
                    .navigationTitle("Settings")
                    .background(AppBackgroundGradient())
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
    }

    private func logout() {
        isLoggedOut = true
    }
    
    private func currencyPicker() -> some View {
        VStack(alignment: .leading) {
            Text("Select Currency")
                .font(.headline)
                .padding(.leading)
            
            Picker("Currency", selection: $selectedCurrency) {
                Text("USD").tag("USD")
                Text("EUR").tag("EUR")
                Text("GBP").tag("GBP")
                // Add more currencies as needed
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }
}

// Section des paramètres
struct SettingsSection: View {
    var title: String
    var items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.mostImportantColor)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                ForEach(items, id: \.title) { item in
                    item
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        }
    }
}

// Élément d'une section
struct SettingsItem: View {
    var title: String
    var icon: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.teal)
                    .padding(.trailing, 10)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(AppColors.supportingColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Vue pour les informations de version
struct VersionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Version")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.mostImportantColor)
                .padding(.top, 20)
            
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
            
            VStack(alignment: .leading, spacing: 10) {
                Text("About This App")
                    .font(.headline)
                    .foregroundColor(AppColors.mostImportantColor)
                
                Text("This app is designed to help you manage your finances and make smarter spending decisions. The app provides personalized recommendations based on your financial habits.")
                    .font(.body)
                    .foregroundColor(.black)
                
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
        .background(AppBackgroundGradient())
    }
    
    func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Unknown"
    }
    
    func getAppBuild() -> String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Unknown"
    }
}

// Vues pour les autres sections
// Vue PrivacyPolicyView
struct PrivacyPolicyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Privacy Policy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.mostImportantColor)
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        Text("1. Introduction")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("This Privacy Policy explains how we collect, use, and protect your personal information when you use our mobile app. By using our app, you agree to the terms of this policy.")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("2. Information We Collect")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("We collect the following types of personal data: Name, email address, location data, usage data.")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    
                    Group {
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
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppBackgroundGradient())
    }
}

// Vue TermsOfServiceView
struct TermsOfServiceView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Terms of Service")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.mostImportantColor)
                .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        Text("1. Introduction")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("These Terms of Service govern your use of our mobile application. By using our app, you agree to these terms.")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("2. Use of the App")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("You may use our app only for lawful purposes and in accordance with these Terms of Service.")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    
                    Group {
                        Text("3. Account Responsibility")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("4. Termination of Access")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("We may terminate or suspend your access to the app at our sole discretion, without notice, for conduct that violates these terms.")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("5. Limitation of Liability")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Our liability for any claims related to the use of the app is limited to the maximum extent permitted by law.")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("6. Contact Us")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("If you have any questions about these Terms of Service, please contact us at support@smartspend.com.")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppBackgroundGradient())
    }
}

// Vue ContactUsView
struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Contact Us")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.mostImportantColor)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Email: support@smartspend.com")
                    .font(.body)
                    .foregroundColor(.blue)
                
                Text("Phone: +1 123 456 7890")
                    .font(.body)
                    .foregroundColor(.blue)
                
                Text("Follow us on social media:")
                    .font(.body)
                    .foregroundColor(.black)
                
                HStack(spacing: 20) {
                    Image("facebook") // Utilisez le nom exact de l'image dans les Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Image("twitter") // Utilisez le nom exact de l'image dans les Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    Image("instagram") // Utilisez le nom exact de l'image dans les Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Prend tout l'espace disponible
        .padding()
        .navigationTitle("Contact Us")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppBackgroundGradient().edgesIgnoringSafeArea(.all)) // Fond couvrant toute la page
    }
}


// Utilitaire pour le fond
struct AppBackgroundGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [AppColors.sand, AppColors.sand.opacity(0.7)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

// Définitions des couleurs

// Extension pour les couleurs hexadécimales
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSettings: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            // Logo
            Image("tnd")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 10)
            
            // Title
            Text("SmartSpend")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.mostImportantColor)
                .padding(.bottom, 5)
            
            // Subtitle
            Text("Change Password")
                .font(.title3)
                .foregroundColor(.supportingColor)
                .padding(.bottom, 20)
            
            VStack(spacing: 15) {
                SecureField("Current Password", text: $oldPassword)
                    .padding()
                    .background(Color.sand)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.sand)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("Confirm New Password", text: $confirmPassword)
                    .padding()
                    .background(Color.sand)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            Button("Change Password") {
                if oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
                    alertMessage = "Please fill in all fields"
                    showAlert = true
                    return
                }
                
                if newPassword != confirmPassword {
                    alertMessage = "New passwords don't match"
                    showAlert = true
                    return
                }
                
                changePassword()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.mostImportantColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.sand.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage == "Password changed successfully!" {
                        // Navigate to settings with TabView
                        navigateToSettings = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let window = windowScene?.windows.first
                            window?.rootViewController = UIHostingController(rootView: 
                                MainView() // This replaces the NavigationView { settingsView() }
                            )
                            window?.makeKeyAndVisible()
                        }
                    }
                }
            )
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide back button
    }
    
    private func changePassword() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            alertMessage = "Not logged in"
            showAlert = true
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/auth/change-password?token=\(token)") else {
            alertMessage = "Invalid URL"
            showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        alertMessage = "Error: \(error.localizedDescription)"
                        showAlert = true
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        alertMessage = "Invalid response from server"
                        showAlert = true
                        return
                    }
                    
                    if httpResponse.statusCode == 201 {
                        alertMessage = "Password changed successfully!"
                        showAlert = true
                    } else if httpResponse.statusCode == 401 {
                        alertMessage = "Current password is incorrect"
                        showAlert = true
                    } else {
                        alertMessage = "Failed to change password (Status: \(httpResponse.statusCode))"
                        showAlert = true
                    }
                }
            }.resume()
        } catch {
            alertMessage = "Error encoding data: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

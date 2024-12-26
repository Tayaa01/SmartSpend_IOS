import SwiftUI

struct ResetPasswordView: View {
    let token: String
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToSignIn: Bool = false
    
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
            Text("Reset Password")
                .font(.title3)
                .foregroundColor(.supportingColor)
                .padding(.bottom, 20)
            
            VStack(spacing: 15) {
                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color.sand)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.sand)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            Button("Reset Password") {
                if newPassword.isEmpty || confirmPassword.isEmpty {
                    alertMessage = "Please fill in all fields"
                    showAlert = true
                    return
                }
                
                if newPassword != confirmPassword {
                    alertMessage = "Passwords don't match"
                    showAlert = true
                    return
                }
                
                resetPassword()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.mostImportantColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            if navigateToSignIn {
                NavigationLink(
                    destination: SignInView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true),
                    isActive: $navigateToSignIn
                ) {
                    EmptyView()
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.sand.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if navigateToSignIn {
                        // Clear all navigation stack and go to SignIn
                        navigateToSignIn = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                            let window = windowScene?.windows.first
                            window?.rootViewController = UIHostingController(rootView: SignInView())
                            window?.makeKeyAndVisible()
                        }
                    }
                }
            )
        }
    }
    
    private func resetPassword() {
        // Print token for debugging
        print("Using token: \(token)")
        
        guard let url = URL(string: "http://localhost:3000/auth/reset-password?token=\(token)") else {
            alertMessage = "Invalid URL"
            showAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["newPassword": newPassword] // Changed from "newPassword" to "password"
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            
            // Print request for debugging
            print("Request URL: \(url)")
            print("Request body: \(String(data: jsonData, encoding: .utf8) ?? "")")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        alertMessage = "Error: \(error.localizedDescription)"
                        showAlert = true
                        return
                    }
                    
                    if let data = data {
                        // Print response for debugging
                        print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Status code: \(httpResponse.statusCode)")
                        
                        if httpResponse.statusCode == 201 {
                            alertMessage = "Password reset successful!"
                            showAlert = true
                            navigateToSignIn = true
                        } else {
                            alertMessage = "Failed to reset password (Status: \(httpResponse.statusCode))"
                            showAlert = true
                        }
                    }
                }
            }.resume()
        } catch {
            alertMessage = "Error encoding data: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

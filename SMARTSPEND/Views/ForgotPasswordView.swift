import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = "" // Bind to capture the email input
    @State private var showAlert: Bool = false // Track alert state
    @State private var alertMessage: String = "" // Custom message for the alert
    @State private var navigateToVerifyCode: Bool = false // Add this
    @State private var isRequestSuccessful: Bool = false // Add this

    // Déclaration des couleurs
    static let mostImportantColor = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255)
    static let importantColor = Color(red: 98 / 255, green: 91 / 255, blue: 113 / 255)
    static let supportingColor = Color(red: 27 / 255, green: 27 / 255, blue: 31 / 255)
    static let sand = Color(red: 229 / 255, green: 221 / 255, blue: 200 / 255)
    static let red = Color(red: 219 / 255, green: 31 / 255, blue: 72 / 255)
    
    var body: some View {
        NavigationView {
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
                    .foregroundColor(Self.mostImportantColor)
                    .padding(.bottom, 5)

                // Subtitle
                Text("Forgot your password?")
                    .font(.title3)
                    .foregroundColor(Self.supportingColor)
                    .padding(.bottom, 20)

                // Input Field
                VStack(spacing: 15) {
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Self.sand)
                        .cornerRadius(10)
                        .foregroundColor(Self.supportingColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Self.supportingColor.opacity(0.5), lineWidth: 1)
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 20)

                // Confirm Button
                Button(action: {
                    // Trigger the API call
                    sendForgotPasswordRequest()
                }) {
                    Text("Send Reset Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Self.mostImportantColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Forgot Password"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if isRequestSuccessful {
                                navigateToVerifyCode = true
                            }
                        }
                    )
                }

                NavigationLink(destination: VerifyCodeView(email: email), isActive: $navigateToVerifyCode) {
                    EmptyView()
                }

                Spacer()

                // Navigation Link to Sign-In
                HStack {
                    Text("Remember your password?")
                        .foregroundColor(Self.supportingColor)
                    NavigationLink("Sign in", destination: SignInView())
                        .foregroundColor(Self.mostImportantColor)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
            }
            .background(Self.sand.ignoresSafeArea())
        }
    }

    private func sendForgotPasswordRequest() {
        guard let url = URL(string: "http://localhost:3000/auth/forgot-password") else {
            alertMessage = "Invalid URL."
            showAlert = true
            return
        }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Request body
        let body: [String: String] = ["email": email]
        guard let httpBody = try? JSONEncoder().encode(body) else {
            alertMessage = "Failed to encode request body."
            showAlert = true
            return
        }
        request.httpBody = httpBody

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    isRequestSuccessful = false
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    isRequestSuccessful = true
                    alertMessage = "Reset code has been sent to your email"
                    showAlert = true
                } else {
                    isRequestSuccessful = false
                    alertMessage = "Failed to send reset link. Please try again."
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

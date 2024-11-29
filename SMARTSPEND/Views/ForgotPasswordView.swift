import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = "" // Bind to capture the email input
    @State private var showAlert: Bool = false // Track alert state
    @State private var alertMessage: String = "" // Custom message for the alert

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
                    .foregroundColor(.purple)
                    .padding(.bottom, 5)

                // Subtitle
                Text("Forgot your password?")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                // Input Field
                VStack(spacing: 15) {
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
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
                        .background(Color.purple)
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
                        dismissButton: .default(Text("OK"))
                    )
                }

                Spacer()

                // Navigation Link to Sign-In
                HStack {
                    Text("Remember your password?")
                        .foregroundColor(.gray)
                    NavigationLink("Sign in", destination: SignInView())
                        .foregroundColor(.purple)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
            }
            .background(Color.white.ignoresSafeArea())
        }
    }

    private func sendForgotPasswordRequest() {
        guard let url = URL(string: "http://localhost:3005/auth/forgot-password") else {
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
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    alertMessage = "A reset link has been sent to \(email). Please check your email."
                    showAlert = true
                } else {
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

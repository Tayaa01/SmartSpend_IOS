import SwiftUI

struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var navigateToHome: Bool = false // Navigation state

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
                    .foregroundColor(Color.purple)
                    .padding(.bottom, 5)

                // Subtitle
                Text("Sign In to continue")
                    .font(.title3)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 20)

                // Input Fields
                VStack(spacing: 15) {
                    TextField("Email", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    SecureField("Password", text:  $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 20)

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Success Message
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                // Forgot Password Link
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // Sign-In Button
                Button(action: {
                    signIn()
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                // Sign-Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink("Sign up", destination: SignUpView())
                        .foregroundColor(.purple)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
            }
            .background(Color.white.ignoresSafeArea())
            .background(
                NavigationLink(
                    destination: MainView(),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
            )
        }
    }

    // Sign In Function
    private func signIn() {
        // Validate the input fields
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        // Create the request URL
        let url = URL(string: "http://localhost:3000/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body
        let body: [String: Any] = [
            "email": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Failed to sign in: \(error.localizedDescription)"
                }
                return
            }

            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorMessage = "No response from server."
                }
                return
            }

            DispatchQueue.main.async {
                if httpResponse.statusCode == 201, let data = data {
                    // Parse the token from the response (assuming it's in the body as a JSON response)
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = jsonResponse["access_token"] as? String {
                            // Save the token locally in UserDefaults
                            UserDefaults.standard.setValue(token, forKey: "access_token")
                            let ttt = UserDefaults.standard.string(forKey: "access_token")
                            print("Successfully logged in! Token: \(ttt)")


                            // Success, navigate to Home screen
                            successMessage = "Successfully logged in!"
                            errorMessage = nil // Clear error message
                            navigateToHome = true // Trigger navigation
                        } else {
                            errorMessage = "Failed to retrieve token."
                        }
                    } catch {
                        errorMessage = "Failed to parse response."
                    }
                } else {
                    // Invalid login credentials or other issues
                    errorMessage = "Invalid credentials. Please try again."
                    successMessage = nil // Clear success message
                }
            }
        }.resume()
    }

}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

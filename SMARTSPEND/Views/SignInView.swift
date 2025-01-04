import SwiftUI

struct SignInView: View {
    // Déclarations des couleurs
    static let mostImportantColor = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255) // Most important
    static let importantColor = Color(red: 98 / 255, green: 91 / 255, blue: 113 / 255)
    static let supportingColor = Color(red: 27 / 255, green: 27 / 255, blue: 31 / 255)
    static let leastImportantColor = Color(red: 21 / 255, green: 82 / 255, blue: 99 / 255)
    static let zinc = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255)
    static let red = Color(red: 219 / 255, green: 31 / 255, blue: 72 / 255)
    static let sand = Color(red: 229 / 255, green: 221 / 255, blue: 200 / 255)
    static let teal = Color(red: 1 / 255, green: 148 / 255, blue: 154 / 255)
    static let navy = Color(red: 32 / 255, green: 90 / 255, blue: 106 / 255)

    // Couleurs additionnelles
    static let lightBlue = Color(red: 173 / 255, green: 216 / 255, blue: 230 / 255)
    static let lightGreen = Color(red: 144 / 255, green: 238 / 255, blue: 144 / 255)
    static let lightCoral = Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255)
    static let lightGoldenrodYellow = Color(red: 250 / 255, green: 250 / 255, blue: 210 / 255)
    static let lightSlateGray = Color(red: 119 / 255, green: 136 / 255, blue: 153 / 255)
    static let lightSteelBlue = Color(red: 176 / 255, green: 196 / 255, blue: 222 / 255)
    static let lightSalmon = Color(red: 255 / 255, green: 160 / 255, blue: 122 / 255)
    static let lightSeaGreen = Color(red: 32 / 255, green: 178 / 255, blue: 170 / 255)

    @State var username: String = ""
    @State var password: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var navigateToHome: Bool = false // Navigation state
    @State private var rememberMe: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Logo
                Image("tnd")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 15)

                // Title
                Text("SmartSpend")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Self.mostImportantColor)
                    .padding(.bottom, 5)

                // Subtitle
                Text("Sign In to continue")
                    .font(.title3)
                    .foregroundColor(Self.supportingColor)
                    .padding(.bottom, 25)

                // Input Fields
                VStack(spacing: 20) {
                    // Username
                    TextField("Email", text: $username)
                        .padding()
                        .background(Self.sand)
                        .cornerRadius(15)
                        .foregroundColor(Self.supportingColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Self.mostImportantColor, lineWidth: 1)
                        )

                    // Password
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Self.sand)
                        .cornerRadius(15)
                        .foregroundColor(Self.supportingColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Self.mostImportantColor, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 30)

                // Remember Me Toggle
                Toggle(isOn: $rememberMe) {
                    Text("Remember Me")
                        .foregroundColor(Self.supportingColor)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Self.red)
                        .fontWeight(.semibold)
                        .padding()
                }

                // Success Message
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(Self.mostImportantColor)
                        .fontWeight(.semibold)
                        .padding()
                }

                // Forgot Password Link
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Self.importantColor)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)

                // Sign-In Button
                Button(action: {
                    signIn()
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Self.mostImportantColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .font(.headline)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)

                Spacer()

                // Sign-Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(Self.supportingColor)
                    NavigationLink("Sign up", destination: SignUpView())
                        .foregroundColor(Self.mostImportantColor)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 25)
            }
            .background(Self.sand.ignoresSafeArea())
            .background(
                NavigationLink(
                    destination: MainView().navigationBarBackButtonHidden(true),
                    isActive: $navigateToHome,
                    label: { EmptyView() }
                )
            )
            .onAppear {
                checkRememberedUser()
            }
        }
    }

    // Check if the user is remembered and the token is still valid
    private func checkRememberedUser() {
        if let token = UserDefaults.standard.string(forKey: "access_token"),
           let tokenTimestamp = UserDefaults.standard.object(forKey: "token_timestamp") as? Date {
            
            // Check if token is still valid (11 hours = 39600 seconds)
            let timeElapsed = Date().timeIntervalSince(tokenTimestamp)
            if timeElapsed < 39600 {
                // Token still valid
                navigateToHome = true
            } else {
                // Token expired
                UserDefaults.standard.removeObject(forKey: "access_token")
                UserDefaults.standard.removeObject(forKey: "token_timestamp")
            }
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
                            UserDefaults.standard.setValue(Date(), forKey: "token_timestamp")
                            if rememberMe {
                                UserDefaults.standard.setValue(username, forKey: "saved_username")
                                UserDefaults.standard.setValue(password, forKey: "saved_password")
                            } else {
                                UserDefaults.standard.removeObject(forKey: "saved_username")
                                UserDefaults.standard.removeObject(forKey: "saved_password")
                            }
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

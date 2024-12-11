import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var navigateToSignIn: Bool = false // To handle navigation on success

    // Déclaration des couleurs
    static let mostImportantColor = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255)
    static let importantColor = Color(red: 98 / 255, green: 91 / 255, blue: 113 / 255)
    static let supportingColor = Color(red: 27 / 255, green: 27 / 255, blue: 31 / 255)
    static let sand = Color(red: 229 / 255, green: 221 / 255, blue: 200 / 255)
    static let red = Color(red: 219 / 255, green: 31 / 255, blue: 72 / 255)
    
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
                .foregroundColor(Self.mostImportantColor)
                .padding(.bottom, 5)
            
            // Subtitle
            Text("Create your account")
                .font(.title3)
                .foregroundColor(Self.supportingColor)
                .padding(.bottom, 20)
            
            // Input Fields
            VStack(spacing: 15) {
                TextField("Full Name", text: $name)
                    .padding()
                    .background(Self.sand)
                    .cornerRadius(10)
                    .foregroundColor(Self.supportingColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Self.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Self.sand)
                    .cornerRadius(10)
                    .foregroundColor(Self.supportingColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Self.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Self.sand)
                    .cornerRadius(10)
                    .foregroundColor(Self.supportingColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Self.supportingColor.opacity(0.5), lineWidth: 1)
                    )
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Self.sand)
                    .cornerRadius(10)
                    .foregroundColor(Self.supportingColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Self.supportingColor.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 20)
            
            // Error Message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(Self.red)
                    .padding()
            }
            
            // Success Message
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(Self.mostImportantColor)
                    .padding()
            }
            
            // Sign-Up Button
            Button(action: {
                // Validate fields
                guard !name.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
                    errorMessage = "Please fill in all fields correctly."
                    return
                }
                
                // Create request
                let url = URL(string: "http://localhost:3005/users")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let body: [String: Any] = [
                    "name": name,
                    "email": email,
                    "password": password
                ]
                
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
                
                // Perform the request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        DispatchQueue.main.async {
                            errorMessage = "No response from server."
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if httpResponse.statusCode == 201 {
                            // Success, show success message and navigate to sign-in
                            successMessage = "Account created successfully!"
                            errorMessage = nil // Clear any previous error message
                            navigateToSignIn = true
                        } else {
                            // Handle errors
                            errorMessage = "Failed to sign up. Please try again."
                            successMessage = nil // Clear any previous success message
                        }
                    }
                }.resume()
            }) {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Self.mostImportantColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Sign-In Link
            HStack {
                Text("Already have an account?")
                    .foregroundColor(Self.supportingColor)
                NavigationLink(destination: SignInView(), isActive: $navigateToSignIn) {
                    Text("Sign in")
                        .foregroundColor(Self.mostImportantColor)
                        .fontWeight(.bold)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Self.sand.ignoresSafeArea())
    }
}

// Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

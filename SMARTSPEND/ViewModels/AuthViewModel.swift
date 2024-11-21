import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var user: UserModel? // Store authenticated user data
    
    // SignIn method
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Call AuthService to perform the sign-in
        AuthService.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    // Handle success (e.g., save user, navigate to next screen, etc.)
                    self?.user = user // Save user data
                    print("Sign-In Success: \(user)")
                case .failure(let error):
                    // Handle failure (e.g., show error message)
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // SignUp method
    func signUp() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please fill in all fields correctly."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Call AuthService to perform the sign-up
        AuthService.shared.signUp(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    // Handle success (e.g., save user, navigate to sign-in screen)
                    self?.user = user // Save user data
                    print("Sign-Up Success: \(user)")
                case .failure(let error):
                    // Handle failure (e.g., show error message)
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

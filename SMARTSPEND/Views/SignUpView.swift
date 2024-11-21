import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("tnd")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("SmartSpend")
                .font(.title)
                .foregroundColor(.white)
            
            Text("Sign Up")
                .font(.title2)
                .bold()
                .foregroundColor(.yellow)
                .padding(.top, 20)
            
            VStack(spacing: 15) {
                TextField("name", text: $viewModel.name) // Bind to ViewModel
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                TextField("Email", text: $viewModel.email) // Bind to ViewModel
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $viewModel.password) // Bind to ViewModel
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                SecureField("Confirm Password", text: $viewModel.confirmPassword) // Bind to ViewModel
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding()
            
            // Show error message if any
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                viewModel.signUp() // Trigger Sign-Up process
            }) {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.white)
                NavigationLink("Sign in", destination: SignInView()) // Navigate to Sign-In screen
                    .foregroundColor(.yellow)
            }
            .padding(.bottom, 10)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

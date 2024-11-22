import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = "" // Bind to capture the email input
    @State private var showConfirmation: Bool = false // Track confirmation state

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Image("tnd")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("SmartSpend")
                    .font(.title)
                    .foregroundColor(.white)

                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }


                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress) // Ensure appropriate keyboard
                        .autocapitalization(.none)
                }
                .padding()

                Button(action: {
                    // Simulate sending the reset link
                    if !email.isEmpty {
                        showConfirmation = true
                    }
                }) {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)
                .alert(isPresented: $showConfirmation) {
                    Alert(
                        title: Text("Reset Link Sent"),
                        message: Text("A reset link has been sent to \(email). Please check your email."),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Spacer()

                HStack {
                    Text("Remember your password?")
                        .foregroundColor(.white)
                    NavigationLink("Sign in", destination: SignInView()) // Link back to Sign In
                        .foregroundColor(.yellow)
                }
                .padding(.bottom, 10)
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

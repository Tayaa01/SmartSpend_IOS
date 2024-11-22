import SwiftUI

struct SignInView: View {
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

                Text("Sign In")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.yellow)
                    .padding(.top, 20)

                VStack(spacing: 15) {
                    TextField("Email", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                    SecureField("Password", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding()

                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) { // Navigate to ForgotPasswordView
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }

                    }
                }
                .padding(.horizontal)

                Button(action: {
                    // Handle Sign-In Action
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)

                Text("Or sign in with")
                    .foregroundColor(.white)
                    .padding(.top, 30)

                HStack(spacing: 20) {
                    Image(systemName: "appleeeeeee")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)

                    Image("googlepic") // Replace with your Google icon
                        .resizable()
                        .frame(width: 30, height: 30)
                }

                Spacer()

                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    NavigationLink("Sign up", destination: SignUpView())
                        .foregroundColor(.yellow)
                }
                .padding(.bottom, 10)
            }
            .background(Color.black.ignoresSafeArea())
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

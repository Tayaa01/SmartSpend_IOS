import SwiftUI

struct VerifyCodeView: View {
    let email: String
    @State private var verificationCode: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToResetPassword: Bool = false
    
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
            Text("Verify Your Code")
                .font(.title3)
                .foregroundColor(.supportingColor)
                .padding(.bottom, 20)
            
            Text("Enter the 6-digit code sent to\n\(email)")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            TextField("000000", text: $verificationCode)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding()
                .background(Color.sand)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.supportingColor.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .onChange(of: verificationCode) { newValue in
                    if newValue.count > 6 {
                        verificationCode = String(newValue.prefix(6))
                    }
                }
            
            Button("Verify Code") {
                if verificationCode.count == 6 {
                    navigateToResetPassword = true
                } else {
                    alertMessage = "Please enter a 6-digit code"
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.mostImportantColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            NavigationLink(
                destination: ResetPasswordView(token: verificationCode)
                    .navigationBarBackButtonHidden(true),
                isActive: $navigateToResetPassword
            ) {
                EmptyView()
            }
            
            Spacer()
        }
        .background(Color.sand.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
    }
}

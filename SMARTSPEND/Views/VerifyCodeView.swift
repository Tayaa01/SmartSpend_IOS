import SwiftUI

struct HeaderView: View {
    let email: String
    
    var body: some View {
        VStack {
            Image("tnd")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 10)
            
            Text("SmartSpend")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.mostImportantColor)
                .padding(.bottom, 5)
            
            Text("Verify Your Code")
                .font(.title3)
                .foregroundColor(.supportingColor)
                .padding(.bottom, 20)
            
            Text("Enter the 6-digit code sent to\n\(email)")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
    }
}

struct OTPTextBox: View {
    @Binding var text: String
    let isCurrentField: Bool
    @FocusState private var isFocused: Bool
    let index: Int
    @Binding var currentField: Int
    
    var body: some View {
        TextField("", text: $text)
            .focused($isFocused)
            .frame(width: 45, height: 45)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isCurrentField ? Color.mostImportantColor : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .onChange(of: text) { newValue in
                if newValue.count > 1 {
                    text = String(newValue.suffix(1))
                }
                if let _ = Int(text) {
                    if index < 5 {
                        currentField = index + 1
                    }
                } else {
                    text = ""
                }
            }
            .onTapGesture {
                currentField = index
            }
            .onChange(of: currentField) { newValue in
                isFocused = (newValue == index)
            }
    }
}

struct OTPInputView: View {
    @Binding var otpFields: [String]
    @Binding var currentField: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<6) { index in
                OTPTextBox(
                    text: $otpFields[index],
                    isCurrentField: currentField == index,
                    index: index,
                    currentField: $currentField
                )
            }
        }
        .padding(.horizontal)
    }
}

struct VerifyCodeView: View {
    let email: String
    @State private var otpFields: [String] = Array(repeating: "", count: 6)
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToResetPassword: Bool = false
    @FocusState private var focusedField: Int?
    @State private var currentField: Int = 0
    @State private var isLoading: Bool = false
    
    var verificationCode: String {
        otpFields.joined()
    }
    
    func verifyToken() async {
        guard let url = URL(string: "http://localhost:3000/auth/verify-reset-token?token=\(verificationCode)") else {
            alertMessage = "Invalid URL"
            showAlert = true
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(VerifyTokenResponse.self, from: data)
            
            DispatchQueue.main.async {
                if response.isValid {
                    navigateToResetPassword = true
                } else {
                    alertMessage = "Invalid verification code"
                    showAlert = true
                }
                isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                alertMessage = "Error verifying code: \(error.localizedDescription)"
                showAlert = true
                isLoading = false
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            HeaderView(email: email)
            
            OTPInputView(otpFields: $otpFields, currentField: $currentField)
            
            Button("Verify Code") {
                if verificationCode.count == 6 {
                    isLoading = true
                    Task {
                        await verifyToken()
                    }
                } else {
                    alertMessage = "Please enter a 6-digit code"
                    showAlert = true
                }
            }
            .disabled(isLoading)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isLoading ? Color.gray : Color.mostImportantColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            
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
        .onAppear {
            focusedField = 0
        }
    }
}

struct VerifyTokenResponse: Codable {
    let isValid: Bool
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SignInView()
                .navigationDestination(for: String.self) { route in
                    if route == "SignUp" {
                        SignUpView()
                    }
                }
        }
    }
}

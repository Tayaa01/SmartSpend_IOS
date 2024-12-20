import SwiftUI

struct AllIncomesView: View {
    @StateObject private var incomesViewModel = IncomesViewModel()
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    
    var body: some View {
        VStack {
            if incomesViewModel.isLoading {
                ProgressView("Loading all incomes...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.sand.opacity(0.7)) // Fond semi-transparent
                    .cornerRadius(10)
            } else if let errorMessage = incomesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            } else {
                if incomesViewModel.incomes.isEmpty {
                    Text("No incomes found")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding()
                } else {
                    List(incomesViewModel.incomes) { income in
                        IncomeCard(income: income, currency: selectedCurrency)
                            .padding(.vertical, 5)
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                incomesViewModel.fetchIncomes(token: token)
            } else {
                incomesViewModel.errorMessage = "User not logged in."
                incomesViewModel.isLoading = false
            }
        }
        .navigationTitle("All Incomes")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.sand) // Fond général
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action pour faire défiler la liste vers le haut
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.mostImportantColor) // Utiliser la couleur importante
                        .font(.title2)
                }
            }
        }
    }
}

struct AllIncomesView_Previews: PreviewProvider {
    static var previews: some View {
        AllIncomesView()
    }
}

// Carte de revenu

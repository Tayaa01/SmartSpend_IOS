import SwiftUI

struct AllExpensesView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()  // Utilisation du ViewModel pour gérer les dépenses
    @State private var showErrorMessage = false
    
    var body: some View {
        VStack {
            // Affichage du ProgressView pendant le chargement des données
            if expensesViewModel.isLoading {
                ProgressView("Loading all expenses...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color.sand.opacity(0.7)) // Ajout d'un fond semi-transparent
                    .cornerRadius(10)
            }
            // Affichage des erreurs si elles existent
            else if let errorMessage = expensesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
            }
            // Si les dépenses sont récupérées, les afficher dans une liste
            else {
                if expensesViewModel.expenses.isEmpty {
                    Text("No expenses found")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding()
                } else {
                    List(expensesViewModel.expenses) { expense in
                        ExpenseCard(expense: expense)
                            .padding(.vertical, 5)
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            // Si le token est disponible, charger les dépenses
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                expensesViewModel.fetchExpenses(token: token)
            } else {
                expensesViewModel.errorMessage = "User not logged in."
                expensesViewModel.isLoading = false
            }
        }
        .navigationTitle("All Expenses")
        .navigationBarTitleDisplayMode(.inline) // Titre de la barre de navigation compact
        .background(Color.sand) // Fond général de la vue
        .toolbar {
            // Option pour faire défiler la liste jusqu'en haut
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Scroll vers le haut de la liste
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.mostImportantColor)
                        .font(.title2)
                }
            }
        }
    }
}

struct AllExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AllExpensesView()
    }
}

// Carte pour chaque dépense

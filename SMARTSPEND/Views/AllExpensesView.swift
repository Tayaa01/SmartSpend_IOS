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
            }
            // Affichage des erreurs si elles existent
            else if let errorMessage = expensesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
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
        .toolbar {
            // Option pour faire défiler la liste jusqu'en haut
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Scroll vers le haut de la liste
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.purple)
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
struct ExpensesCard: View {
    var expense: Expense
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Format de la date
        return formatter
    }

    private func formattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Assurez-vous que la date soit dans ce format
        
        if let date = formatter.date(from: string) {
            return dateFormatter.string(from: date)  // Retourne la date formatée
        }
        return string  // Si la conversion échoue, retourne la chaîne d'origine
    }
    
    var body: some View {
        HStack {
            // Affichage d'une icône de catégorie
            Image(systemName: "tag.fill")
                .font(.title)
                .foregroundColor(.purple)
                .frame(width: 40, height: 40)
                .background(Color.purple.opacity(0.2))
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            // Informations sur la dépense
            VStack(alignment: .leading) {
                HStack {
                    Text(expense.description)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                HStack {
                    Text("Date:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(formattedDate(from: expense.date))
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.top, 2)
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

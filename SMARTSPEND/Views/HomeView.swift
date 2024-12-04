import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            TabView {
                // Onglet Home
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                // Onglet Expenses
                
                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")  // Icône de graphique
                    }
                RecommendationsView()
                    .tabItem {
                        Label("Recomendations", systemImage: "lightbulb.fill")  // Icône de graphique
                    }

                // Onglet Settings
                settingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                
            }
            
        }
    }
}




// Vue HomeView
struct HomeView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()
    @StateObject private var incomesViewModel = IncomesViewModel() // ViewModel pour les revenus
    @State private var showAddExpenseOrIncome: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Loading State for Expenses
                if expensesViewModel.isLoading {
                    ProgressView("Loading expenses...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = expensesViewModel.errorMessage {
                    // Error Message for Expenses
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Expenses List
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Last 3 Expenses")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .padding(.top)

                        ForEach(expensesViewModel.expenses.prefix(3)) { expense in
                            ExpenseCard(expense: expense)
                        }

                        NavigationLink("View All", destination: AllExpensesView())
                            .foregroundColor(.purple)
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal)
                }
                
                Divider()

                // Loading State for Incomes
                if incomesViewModel.isLoading {
                    ProgressView("Loading incomes...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = incomesViewModel.errorMessage {
                    // Error Message for Incomes
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Incomes List
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Last 3 Incomes")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .padding(.top)

                        ForEach(incomesViewModel.incomes.prefix(3)) { income in
                            IncomeCard(income: income)
                        }

                        NavigationLink("View All", destination: AllIncomesView())
                            .foregroundColor(.purple)
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                expensesViewModel.fetchExpenses(token: token)
                incomesViewModel.fetchIncomes(token: token) // Fetch incomes data
            } else {
                expensesViewModel.errorMessage = "User not logged in."
                expensesViewModel.isLoading = false
                incomesViewModel.errorMessage = "User not logged in."
                incomesViewModel.isLoading = false
            }
        }
        .overlay(
            Button(action: {
                showAddExpenseOrIncome.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.purple)
            .clipShape(Circle())
            .shadow(radius: 10)
            .padding(.bottom, 30)
            .padding(.trailing, 20),
            alignment: .bottomTrailing
        )
        .navigationTitle("Home")
        .sheet(isPresented: $showAddExpenseOrIncome) {
            AddExpenseOrIncomeView()
        }
    }
}

// Vue pour afficher toutes les dépenses


// Vue pour afficher toutes les sources de revenus


// Carte de dépense
struct ExpenseCard: View {
    var expense: Expense
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Format année-mois-jour
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
        VStack(alignment: .leading, spacing: 10) {
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
            .padding()
            
            Divider()

            HStack {
                Text("Date:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                
                // Affichage de la date formatée
                Text(formattedDate(from: expense.date))
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Carte de revenu
struct IncomeCard: View {
    var income: Income
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Format année-mois-jour
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(income.description)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()

                Text("$\(income.amount, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding()
            
            Divider()

            HStack {
                Text("Date:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                
                // Affichage de la date formatée
                Text(formattedDate(from: income.date))
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Autres vues
struct ExpensesView: View {
    var body: some View {
        Text("Expenses View")
            .font(.largeTitle)
    }
}

struct IncomesView: View {
    var body: some View {
        Text("Incomes View")
            .font(.largeTitle)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
            .font(.largeTitle)
    }
}

// Vue pour ajouter une dépense
struct AddExpenseView: View {
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    
    var body: some View {
        VStack {
            Text("Add Expense")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Description", text: $description)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
           
            TextField("Category", text: $category)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                // Logique pour soumettre la dépense
                print("Expense Added: \(amount), Description: \(description), Category: \(category)")
            }) {
                Text("Add Expense")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
    }
}

// Aperçu
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

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
                AddExpenseView()
                    .tabItem {
                        Label("Expenses", systemImage: "list.bullet")
                    }

                // Onglet Incomes
                IncomesView()
                    .tabItem {
                        Label("Incomes", systemImage: "creditcard.fill")
                    }

                // Onglet Settings
                settingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .accentColor(.purple)
            
            .navigationBarItems(leading: ProfileButton())
        }
    }
}

// Bouton de profil en haut à gauche
struct ProfileButton: View {
    @State private var showProfileSheet: Bool = false
    @State private var userName: String = "John Doe"
    @State private var userEmail: String = "johndoe@example.com"
    
    var body: some View {
        Button(action: {
            showProfileSheet.toggle()
        }) {
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(.purple)
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileView(userName: userName, userEmail: userEmail)
        }
    }
}

// Vue pour afficher les informations utilisateur
struct ProfileView: View {
    var userName: String
    var userEmail: String
    
    var body: some View {
        VStack {
            Text("User Profile")
                .font(.largeTitle)
                .padding()

            Text("Name: \(userName)")
                .font(.title2)
                .padding()

            Text("Email: \(userEmail)")
                .font(.title2)
                .padding()

            Spacer()
        }
        .padding()
    }
}

// Vue HomeView
struct HomeView: View {
    @StateObject private var viewModel = ExpensesViewModel()
    @State private var showAddExpenseOrIncome: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Loading State
                if viewModel.isLoading {
                    ProgressView("Loading expenses...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    // Error Message
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

                        ForEach(viewModel.expenses.prefix(3)) { expense in
                            ExpenseCard(expense: expense)
                        }

                        NavigationLink("View All", destination: Text("All Expenses"))
                            .foregroundColor(.purple)
                            .padding(.bottom, 10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                viewModel.fetchExpenses(token: token)
            } else {
                viewModel.errorMessage = "User not logged in."
                viewModel.isLoading = false
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
            AddExpenseView()
        }
    }
}

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

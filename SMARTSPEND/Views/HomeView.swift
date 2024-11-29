import SwiftUI

struct MainView: View {
    var body: some View {
        // Envelopper TabView dans un NavigationView pour éviter les conflits
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
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .accentColor(.purple) // Personnalise la couleur de l'onglet sélectionné
            .navigationTitle("Main View") // Titre global de la navigation
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
    @State private var showAddExpenseOrIncome: Bool = false

    let expenses = [("Groceries", 50.0), ("Transport", 20.0), ("Utilities", 30.0)]
    let incomes = [("Salary", 1500.0), ("Freelance", 500.0), ("Gift", 200.0)]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Carte pour le solde
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Balance")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("$2000.00")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Expense")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("-$100.00")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Income")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("$2000.00")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(15)
                }
                .padding(.horizontal)

                // Dernières dépenses
                VStack(alignment: .leading, spacing: 10) {
                    Text("Last 3 Expenses")
                        .font(.headline)
                        .foregroundColor(.purple)
                    ForEach(expenses.prefix(3), id: \.0) { expense in
                        HStack {
                            Text(expense.0)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(expense.1, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    NavigationLink("View All", destination: Text("All Expenses"))
                        .foregroundColor(.purple)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal)

                // Derniers revenus
                VStack(alignment: .leading, spacing: 10) {
                    Text("Last 3 Incomes")
                        .font(.headline)
                        .foregroundColor(.purple)
                    ForEach(incomes.prefix(3), id: \.0) { income in
                        HStack {
                            Text(income.0)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(income.1, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    NavigationLink("View All", destination: Text("All Incomes"))
                        .foregroundColor(.purple)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal)
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

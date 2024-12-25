import SwiftUI

// MARK: - Couleurs personnalisées
extension Color {
    static let mostImportantColor = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255) // Most important
    static let importantColor = Color(red: 98 / 255, green: 91 / 255, blue: 113 / 255)
    static let supportingColor = Color(red: 27 / 255, green: 27 / 255, blue: 31 / 255)
    static let leastImportantColor = Color(red: 21 / 255, green: 82 / 255, blue: 99 / 255)
    static let zinc = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255)
    static let red = Color(red: 219 / 255, green: 31 / 255, blue: 72 / 255)
    static let sand = Color(red: 229 / 255, green: 221 / 255, blue: 200 / 255)
    static let sandDark = Color(red: 204 / 255, green: 194 / 255, blue: 174 / 255) // Darker version of Color.sand
    static let teal = Color(red: 1 / 255, green: 148 / 255, blue: 154 / 255)
    static let navy = Color(red: 32 / 255, green: 90 / 255, blue: 106 / 255)
    static let lightGreen = Color(red: 144 / 255, green: 238 / 255, blue: 144 / 255)
}

// MARK: - Main View
struct MainView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                StatisticsView()
                    .tabItem {
                        Label("Statistics", systemImage: "chart.bar.fill")
                    }

                RecommendationsView()
                    .tabItem {
                        Label("Recommendations", systemImage: "lightbulb.fill")
                    }

                settingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .accentColor(.mostImportantColor)
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()
    @StateObject private var incomesViewModel = IncomesViewModel()
    @State private var showAddExpenseOrIncome: Bool = false
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    ZStack {
                        // Image d'arrière-plan
                        Image("homebackground")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300) // Ajuster la hauteur de l'image
                            .clipped() // S'assure que l'image ne dépasse pas les bords
                        
                        VStack {
                            Spacer(minLength: 170)

                            BalanceCardView(
                                totalIncome: incomesViewModel.totalIncome,
                                totalExpenses: expensesViewModel.totalExpenses,
                                currency: selectedCurrency
                            )
                            .padding(16.0)
                        }
                    }
                    .padding(.top, -50) // Ensure the image is the first thing on top

                    Divider().padding(.horizontal)

                    // Last 3 Expenses Section with View All button in the same row
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Last 3 Expenses")
                                .font(.headline)
                                .foregroundColor(.mostImportantColor)
                            Spacer()
                            NavigationLink(destination: AllExpensesView()) {
                                Text("View All")
                                    .foregroundColor(.mostImportantColor)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(expensesViewModel.expenses.prefix(3)) { expense in
                                    ExpenseCard(expense: expense, currency: selectedCurrency)
                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    // Last 3 Incomes Section with View All button in the same row
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Last 3 Incomes")
                                .font(.headline)
                                .foregroundColor(.mostImportantColor)
                            Spacer()
                            NavigationLink(destination: AllIncomesView()) {
                                Text("View All")
                                    .foregroundColor(.mostImportantColor)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(incomesViewModel.incomes.prefix(3)) { income in
                                    IncomeCard(income: income, currency: selectedCurrency)
                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .onAppear {
                if let token = UserDefaults.standard.string(forKey: "access_token") {
                    expensesViewModel.fetchExpenses(token: token)
                    incomesViewModel.fetchIncomes(token: token)
                } else {
                    expensesViewModel.errorMessage = "User not logged in."
                    incomesViewModel.errorMessage = "User not logged in."
                }
            }
            .overlay(
                FloatingAddButton(action: {
                    showAddExpenseOrIncome.toggle()
                })
                .padding(.trailing, 20)
                .padding(.bottom, 30),
                alignment: .bottomTrailing
            )
            .sheet(isPresented: $showAddExpenseOrIncome) {
                AddExpenseOrIncomeView()
            }
            .background(Color.sand) // Background color of the screen
            .edgesIgnoringSafeArea(.all) // Optional, if you want to extend the background to the edges
        }
    }
}

// BalanceCardView
struct BalanceCardView: View {
    var totalIncome: Double
    var totalExpenses: Double
    var currency: String

    private func currencySymbol() -> String {
        switch currency {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        default:
            return "$"
        }
    }

    var body: some View {
        ZStack {
            Color.navy
                .cornerRadius(20)
                .shadow(radius: 10)

            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Balance")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        let balance = totalIncome - totalExpenses
                        Text("\(currencySymbol())\(balance, specifier: "%.2f")")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }

                Divider()
                    .background(Color.white.opacity(0.3))

                HStack(spacing: 40) {
                    VStack {
                        HStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.red)
                                )
                            Text("Expenses")
                                .foregroundColor(.white)
                        }
                        Text("\(currencySymbol())\(totalExpenses, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.red)
                    }

                    VStack {
                        HStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.green)
                                )
                            Text("Income")
                                .foregroundColor(.white)
                        }
                        Text("\(currencySymbol())\(totalIncome, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
        }
        .frame(height: 160) // Reduced from 180
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20) // Adjusted horizontal padding
    }
}

// ExpenseCard
struct ExpenseCard: View {
    var expense: Expense
    var currency: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Format de la date
        return formatter
    }

    private func formattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Assurez-vous que la date soit dans ce format
        
        if let date = formatter.date(from: string) {
            return dateFormatter.string(from: date).prefix(10).description  // Retourne les 10 premiers caractères de la date formatée
        }
        return string.prefix(10).description  // Si la conversion échoue, retourne les 10 premiers caractères de la chaîne d'origine
    }
    
    private func currencySymbol() -> String {
        switch currency {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        default:
            return "$"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "tag.fill")
                    .font(.title)
                    .foregroundColor(.mostImportantColor)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.mostImportantColor.opacity(0.2))) // Icône arrondie avec fond coloré
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(expense.description)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(formattedDate(from: expense.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("\(currencySymbol())\(expense.amount, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity) // Utilisation de la largeur maximale de la carte
    }
}

// IncomeCard
struct IncomeCard: View {
    var income: Income
    var currency: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Format de la date
        return formatter
    }

    private func formattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Assurez-vous que la date soit dans ce format
        
        if let date = formatter.date(from: string) {
            return dateFormatter.string(from: date).prefix(10).description  // Retourne les 10 premiers caractères de la date formatée
        }
        return string.prefix(10).description  // Si la conversion échoue, retourne les 10 premiers caractères de la chaîne d'origine
    }
    
    private func currencySymbol() -> String {
        switch currency {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        default:
            return "$"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title)
                    .foregroundColor(.mostImportantColor) // Utilisation de la couleur importante
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.mostImportantColor.opacity(0.2))) // Icône arrondie avec fond coloré
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(income.description)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(formattedDate(from: income.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("\(currencySymbol())\(income.amount, specifier: "%.2f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
        .frame(maxWidth: .infinity) // Utilisation de la largeur maximale
    }
}

// Floating Add Button
struct FloatingAddButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.mostImportantColor))
                .shadow(radius: 10)
        }
        .padding(.trailing, 30)
        .padding(.bottom, 50) // Changed from 100 to 50 to lower the button position
    }
}

// MARK: - Card Section View (Generic for both Expenses and Incomes)
struct CardSectionView<Item: Identifiable, Content: View, Destination: View>: View {
    var title: String
    var items: ArraySlice<Item>
    var isLoading: Bool
    var errorMessage: String?
    var cardContent: (Item) -> Content
    var navigationDestination: Destination

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.mostImportantColor)
                Spacer()
            }
            .padding(.vertical, 8)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(items) { item in
                            NavigationLink(destination: navigationDestination) {
                                cardContent(item)
                                    .padding(.trailing, 16)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Previews
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

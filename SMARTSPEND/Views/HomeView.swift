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

struct HomeView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()
    @StateObject private var incomesViewModel = IncomesViewModel()
    @State private var showAddExpenseOrIncome: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ZStack {
                    Color.sand
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .shadow(color: Color.sand.opacity(0.3), radius: 8, x: 0, y: 4)
                        .padding(-20)
                    VStack
                    {
                        Spacer(minLength: 50)
                        
                        BalanceCardView(totalIncome: incomesViewModel.totalIncome, totalExpenses: expensesViewModel.totalExpenses)
                            .padding(16.0)
                        
                    }
                }

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Spending Overview")
                        .font(.headline)
                        .foregroundColor(.mostImportantColor)

                    let progress = (incomesViewModel.totalIncome > 0) ? expensesViewModel.totalExpenses / incomesViewModel.totalIncome : 0

                    ProgressBar(value: progress)
                        .frame(height: 20)
                        .padding()
                        .background(Color.sandDark) // Use darker sand color for the progress bar
                        .cornerRadius(12)
                        .shadow(color: Color.sandDark.opacity(0.3), radius: 6, x: 0, y: 2)

                    Text("Spent: $\(expensesViewModel.totalExpenses, specifier: "%.2f") / $\(incomesViewModel.totalIncome, specifier: "%.2f")")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

                Divider().padding(.horizontal)

                CardSectionView(
                    title: "Last 3 Expenses",
                    items: expensesViewModel.expenses.prefix(3),
                    isLoading: expensesViewModel.isLoading,
                    errorMessage: expensesViewModel.errorMessage,
                    cardContent: { expense in
                        ExpenseCard(expense: expense) // Using the ExpenseCard with updated background color
                    },
                    navigationDestination: AllExpensesView()
                )

                Divider().padding(.horizontal)

                CardSectionView(
                    title: "Last 3 Incomes",
                    items: incomesViewModel.incomes.prefix(3),
                    isLoading: incomesViewModel.isLoading,
                    errorMessage: incomesViewModel.errorMessage,
                    cardContent: { income in
                        IncomeCard(income: income) // Using the IncomeCard with updated background color
                    },
                    navigationDestination: AllIncomesView()
                )
            }
            .padding(.horizontal)
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
        .navigationTitle("Home")
        .foregroundColor(.mostImportantColor)
        .background(Color.sand) // Background color of the screen
        .edgesIgnoringSafeArea(.all) // Optional, if you want to extend the background to the edges
    }
}

// MARK: - Balance Card View
struct BalanceCardView: View {
    var totalIncome: Double
    var totalExpenses: Double

    var body: some View {
        ZStack {
            Color.sandDark // Apply darker color to all cards, including the balance card
                .cornerRadius(12)
                .shadow(color: Color.sandDark.opacity(0.3), radius: 6, x: 0, y: 2)

            VStack(spacing: 15) {
                Text("Account Balance")
                    .font(.headline)
                    .foregroundColor(.mostImportantColor)

                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Income: $\(totalIncome, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.mostImportantColor)

                        Text("Total Expenses: $\(totalExpenses, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }

                    Spacer()

                    let balance = totalIncome - totalExpenses
                    Text("Balance: $\(balance, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(balance >= 0 ? .mostImportantColor : .red)
                }
            }
            .padding()
            .background(Color.sandDark) // Apply darker background here as well
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Progress Bar (Custom)
struct ProgressBar: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Color.gray.opacity(0.3)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .cornerRadius(geometry.size.height / 2)
                Color.mostImportantColor
                    .frame(width: geometry.size.width * CGFloat(value), height: geometry.size.height)
                    .cornerRadius(geometry.size.height / 2)
            }
        }
    }
}

// MARK: - Expense and Income Cards
struct ExpenseCard: View {
    var expense: Expense

    var body: some View {
        VStack(alignment: .leading) {
            Text(expense.description)
                .font(.headline)
            Text("$\(expense.amount, specifier: "%.2f")")
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.sandDark) // Use the darker color for the cards
        .cornerRadius(12)
        .shadow(color: Color.sandDark.opacity(0.3), radius: 6, x: 0, y: 2)
    }
}

struct IncomeCard: View {
    var income: Income

    var body: some View {
        VStack(alignment: .leading) {
            Text(income.description)
                .font(.headline)
            Text("$\(income.amount, specifier: "%.2f")")
                .foregroundColor(.mostImportantColor)
        }
        .padding()
        .background(Color.sandDark) // Use the darker color for the cards
        .cornerRadius(12)
        .shadow(color: Color.sandDark.opacity(0.3), radius: 6, x: 0, y: 2)
    }
}

// Floating Add Button
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
        .padding(.trailing, 30) // Adjust right padding to move horizontally
        .padding(.bottom, 100) // Adjust bottom padding to move vertically
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

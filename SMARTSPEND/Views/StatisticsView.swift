import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()
    @StateObject private var incomesViewModel = IncomesViewModel()

    @State private var totalExpensesAmount: Double = 0
    @State private var totalIncomesAmount: Double = 0
    @State private var netBalanceAmount: Double = 0
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @State private var categories: [Category] = []
    @State private var isLoadingCategories: Bool = true
    
    // Couleurs
    static let sand = Color(red: 229 / 255, green: 221 / 255, blue: 200 / 255)
    static let sandDark = Color(red: 200 / 255, green: 180 / 255, blue: 160 / 255)
    static let mostImportantColor = Color(red: 47 / 255, green: 126 / 255, blue: 121 / 255)
    
    var body: some View {
        NavigationView {
            VStack {
                if (expensesViewModel.isLoading || incomesViewModel.isLoading) {
                    ProgressView("Loading statistics...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = expensesViewModel.errorMessage ?? incomesViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Spacer(minLength: 30)

                            // Section Résumé
                            StatSectionView(
                                title: "Summary",
                                stats: [
                                    StatData(title: "Total Expenses", value: totalExpensesAmount, color: .red, icon: "arrow.down.circle.fill"),
                                    StatData(title: "Total Incomes", value: totalIncomesAmount, color: .green, icon: "arrow.up.circle.fill"),
                                    StatData(title: "Net Balance", value: netBalanceAmount, color: netBalanceAmount < 0 ? .red : .green, icon: "equal.circle.fill")
                                ],
                                currency: selectedCurrency
                            )

                            // Progress bar pour la comparaison Dépenses vs Revenus
                            progressBarSection()

                            // Autres Statistiques
                            detailedInsightsSection()
                            
                            // Additional Statistics
                            additionalStatisticsSection()

                            // Charts and Graphs
                            chartsAndGraphsSection()
                        }
                        .padding()
                    }
                }
            }
            .background(Self.sand)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                if let token = UserDefaults.standard.string(forKey: "access_token") {
                    expensesViewModel.fetchExpenses(token: token)
                    incomesViewModel.fetchIncomes(token: token)
                    fetchCategories() // Add categories fetch
                } else {
                    expensesViewModel.errorMessage = "User not logged in."
                    incomesViewModel.errorMessage = "User not logged in."
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: expensesViewModel.expenses) { _ in updateStatistics() }
            .onChange(of: incomesViewModel.incomes) { _ in updateStatistics() }
        }
    }
    
    private func updateStatistics() {
        totalExpensesAmount = expensesViewModel.expenses.reduce(0) { $0 + $1.amount }
        totalIncomesAmount = incomesViewModel.incomes.reduce(0) { $0 + $1.amount }
        netBalanceAmount = totalIncomesAmount - totalExpensesAmount
    }
    
    private func progressBarSection() -> some View {
        VStack(alignment: .leading) {
            Text("Expenses vs Incomes")
                .font(.headline)
                .padding(.leading)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Expenses")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Spacer()
                    Text("\(selectedCurrency) \(totalExpensesAmount, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                // ProgressBar combinée pour les Dépenses par rapport aux Revenus
                ProgressBar(value: totalExpensesAmount, total: totalIncomesAmount, color: .red)
                
                // Affichage du pourcentage de dépenses par rapport aux revenus
                Text("\(totalIncomesAmount > 0 ? Int((totalExpensesAmount / totalIncomesAmount) * 100) : 0)% Spent")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .padding(.horizontal)
        }
    }
    
    private func detailedInsightsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Detailed Insights")
                .font(.headline)
                .padding(.leading)
            
            HStack {
                ProgressCard(title: "Average Expenses", value: totalExpensesAmount / Double(max(1, expensesViewModel.expenses.count)), total: totalExpensesAmount, color: .red, currency: selectedCurrency)
                ProgressCard(title: "Average Incomes", value: totalIncomesAmount / Double(max(1, incomesViewModel.incomes.count)), total: totalIncomesAmount, color: .green, currency: selectedCurrency)
            }
        }
    }
    
    private func additionalStatisticsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Additional Statistics")
                .font(.headline)
                .padding(.leading)
            
            HStack {
                ProgressCard(title: "Highest Expense", value: expensesViewModel.expenses.map { $0.amount }.max() ?? 0, total: totalExpensesAmount, color: .red, currency: selectedCurrency)
                ProgressCard(title: "Highest Income", value: incomesViewModel.incomes.map { $0.amount }.max() ?? 0, total: totalIncomesAmount, color: .green, currency: selectedCurrency)
            }
            
            HStack {
                ProgressCard(title: "Lowest Expense", value: expensesViewModel.expenses.map { $0.amount }.min() ?? 0, total: totalExpensesAmount, color: .red, currency: selectedCurrency)
                ProgressCard(title: "Lowest Income", value: incomesViewModel.incomes.map { $0.amount }.min() ?? 0, total: totalIncomesAmount, color: .green, currency: selectedCurrency)
            }
        }
    }

    private func fetchCategories() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            return
        }

        let url = URL(string: "http://localhost:3000/categories")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
                        self.categories = decodedCategories
                        self.isLoadingCategories = false
                    } catch {
                        print("Failed to decode categories: \(error)")
                    }
                }
            }
        }.resume()
    }

    private func getCategoryName(for id: String) -> String {
        categories.first(where: { $0.id == id })?.name ?? "Unknown"
    }

    private func groupExpensesByCategory() -> [(String, Double)] {
        let grouped = Dictionary(grouping: expensesViewModel.expenses) { expense in
            getCategoryName(for: expense.category) // Use category name instead of ID
        }
        .mapValues { expenses in
            expenses.reduce(0) { $0 + $1.amount }
        }
        return grouped.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }

    private func chartsAndGraphsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Charts and Graphs")
                .font(.headline)
                .padding(.leading)
            
            let groupedExpenses = groupExpensesByCategory()
            
            // Pie Chart with grouped data
            PieChartView(
                data: groupedExpenses.map { $0.1 },
                labels: groupedExpenses.map { $0.0 }
            )
            .frame(height: 300)
            .padding(.horizontal)
            
            // Bar Chart with grouped data
            BarChartView(
                data: groupedExpenses.map { $0.1 },
                labels: groupedExpenses.map { $0.0 }
            )
            .frame(height: 300)
            .padding(.horizontal)
        }
    }
}

struct StatSectionView: View {
    let title: String
    let stats: [StatData]
    let currency: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(stats) { stat in
                        StatCard(data: stat, currency: currency)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct StatData: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
    let color: Color
    let icon: String
}

struct StatCard: View {
    let data: StatData
    let currency: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: data.icon)
                .font(.largeTitle)
                .foregroundColor(data.color)
            Text(data.title)
                .font(.subheadline)
                .fontWeight(.medium)
            Text("\(currency) \(data.value, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(data.color)
        }
        .padding()
        .frame(width: 150, height: 150)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct CircleProgressBar: View {
    var amount: Double
    var totalAmount: Double
    var color: Color
    
    private var percentage: CGFloat {
        totalAmount > 0 ? CGFloat(amount / totalAmount) : 0
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .foregroundColor(color.opacity(0.2))
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: percentage)
            Text("\(Int(percentage * 100))%")
                .font(.footnote)
                .foregroundColor(color)
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: Double
    let total: Double
    let color: Color
    let currency: String
    
    var body: some View {
        VStack {
            CircleProgressBar(amount: value, totalAmount: total, color: color)
                .frame(width: 100, height: 100)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            Text("\(currency) \(value, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(color)
        }
        .frame(width: 120)
        .padding()
    }
}

struct ProgressBar: View {
    var value: Double
    var total: Double
    var color: Color
    var backgroundColor: Color = .gray.opacity(0.2)
    var height: CGFloat = 20
    
    private var progress: CGFloat {
        total > 0 ? CGFloat(value / total) : 0
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height / 2)
                .fill(backgroundColor)
                .frame(height: height)
            
            RoundedRectangle(cornerRadius: height / 2)
                .fill(color)
                .frame(width: progress * UIScreen.main.bounds.width * 0.8, height: height)
                .animation(.easeInOut, value: progress)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct PieChartView: View {
    var data: [Double]
    var labels: [String]
    
    var body: some View {
        Chart {
            ForEach(0..<data.count, id: \.self) { index in
                SectorMark(
                    angle: .value("Amount", data[index]),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(by: .value("Label", labels[index]))
            }
        }
        .chartLegend(.visible)
    }
}

struct BarChartView: View {
    var data: [Double]
    var labels: [String]
    
    var body: some View {
        Chart {
            ForEach(0..<data.count, id: \.self) { index in
                BarMark(
                    x: .value("Label", labels[index]),
                    y: .value("Amount", data[index])
                )
                .foregroundStyle(by: .value("Label", labels[index]))
            }
        }
        .chartLegend(.visible)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}

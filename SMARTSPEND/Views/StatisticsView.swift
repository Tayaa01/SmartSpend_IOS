import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var expensesViewModel = ExpensesViewModel()
    @StateObject private var incomesViewModel = IncomesViewModel()
    
    @State private var totalExpensesAmount: Double = 0
    @State private var totalIncomesAmount: Double = 0
    @State private var averageExpensesAmount: Double = 0
    @State private var averageIncomesAmount: Double = 0
    @State private var netBalanceAmount: Double = 0
    @State private var highestExpenseAmount: Double = 0
    @State private var highestIncomeAmount: Double = 0
    
    var body: some View {
        VStack {
            if expensesViewModel.isLoading || incomesViewModel.isLoading {
                ProgressView("Loading statistics...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = expensesViewModel.errorMessage ?? incomesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Total Expenses
                        StatCard(title: "Total Expenses", amount: totalExpensesAmount, color: .red, icon: "arrow.down.circle.fill")
                        
                        // Total Incomes
                        StatCard(title: "Total Incomes", amount: totalIncomesAmount, color: .green, icon: "arrow.up.circle.fill")
                        
                        // Net Balance
                        StatCard(title: "Net Balance", amount: netBalanceAmount, color: netBalanceAmount < 0 ? .red : .green, icon: "circle.fill")
                        
                        // Average Expenses
                        StatCard(title: "Average Expenses", amount: averageExpensesAmount, color: .purple, icon: "chart.bar.xaxis")
                        
                        // Average Incomes
                        StatCard(title: "Average Incomes", amount: averageIncomesAmount, color: .purple, icon: "chart.bar")
                        
                        // Highest Expense
                        StatCard(title: "Highest Expense", amount: highestExpenseAmount, color: .orange, icon: "flame.fill")
                        
                        // Highest Income
                        StatCard(title: "Highest Income", amount: highestIncomeAmount, color: .blue, icon: "dollarsign.circle.fill")
                        
                        // Bar Chart for Expenses and Incomes
                        Chart {
                            BarMark(
                                x: .value("Category", "Expenses"),
                                y: .value("Amount", totalExpensesAmount)
                            )
                            .foregroundStyle(.red)
                            
                            BarMark(
                                x: .value("Category", "Incomes"),
                                y: .value("Amount", totalIncomesAmount)
                            )
                            .foregroundStyle(.green)
                        }
                        .frame(height: 300)
                        .padding(.top)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                expensesViewModel.fetchExpenses(token: token)
                incomesViewModel.fetchIncomes(token: token)
            } else {
                expensesViewModel.errorMessage = "User not logged in."
                incomesViewModel.errorMessage = "User not logged in."
                expensesViewModel.isLoading = false
                incomesViewModel.isLoading = false
            }
        }
        .navigationTitle("Statistics")
        .onChange(of: expensesViewModel.expenses) { _ in
            updateStatistics()
        }
        .onChange(of: incomesViewModel.incomes) { _ in
            updateStatistics()
        }
    }
    
    private func updateStatistics() {
        totalExpensesAmount = expensesViewModel.expenses.reduce(0) { $0 + $1.amount }
        totalIncomesAmount = incomesViewModel.incomes.reduce(0) { $0 + $1.amount }
        averageExpensesAmount = expensesViewModel.expenses.isEmpty ? 0 : totalExpensesAmount / Double(expensesViewModel.expenses.count)
        averageIncomesAmount = incomesViewModel.incomes.isEmpty ? 0 : totalIncomesAmount / Double(incomesViewModel.incomes.count)
        netBalanceAmount = totalIncomesAmount - totalExpensesAmount
        
        // Additional Statistics
        highestExpenseAmount = expensesViewModel.expenses.max { $0.amount < $1.amount }?.amount ?? 0
        highestIncomeAmount = incomesViewModel.incomes.max { $0.amount < $1.amount }?.amount ?? 0
    }
}

struct StatCard: View {
    var title: String
    var amount: Double
    var color: Color
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text("\(title): $\(amount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}

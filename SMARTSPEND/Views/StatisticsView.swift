import SwiftUI

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
                    VStack {
                        Spacer(minLength: 40)
                        
                        // Stat Cards for Total Expenses, Total Incomes, and Net Balance
                      
                        // Combined Pie Chart for Expenses vs Incomes
                        VStack(alignment: .leading) {
                            Text("Expenses vs Incomes")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            HStack {
                                VStack {
                                    Text("Expenses")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                    CircleProgressBar(amount: totalExpensesAmount, totalAmount: totalExpensesAmount + totalIncomesAmount, color: .red)
                                    Text("$\(totalExpensesAmount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("Incomes")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    CircleProgressBar(amount: totalIncomesAmount, totalAmount: totalExpensesAmount + totalIncomesAmount, color: .green)
                                    Text("$\(totalIncomesAmount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.top)
                        }
                        
                        // Additional Statistical Aspects with CircleProgressBar
                        VStack(alignment: .leading, spacing: 25) {
                            Text("Additional Statistics")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            // Net Balance Circle
                            HStack {
                                VStack {
                                    Text("Net Balance")
                                        .font(.subheadline)
                                        .foregroundColor(netBalanceAmount < 0 ? .red : .green)
                                    CircleProgressBar(amount: abs(netBalanceAmount), totalAmount: abs(netBalanceAmount) + totalExpensesAmount + totalIncomesAmount, color: netBalanceAmount < 0 ? .red : .green)
                                    Text("$\(netBalanceAmount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(netBalanceAmount < 0 ? .red : .green)
                                }
                            }
                            
                            // Average Expenses and Incomes Circle
                            HStack {
                                VStack {
                                    Text("Average Expenses")
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                    CircleProgressBar(amount: averageExpensesAmount, totalAmount: totalExpensesAmount + totalIncomesAmount, color: .red)
                                    Text("$\(averageExpensesAmount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("Average Incomes")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                    CircleProgressBar(amount: averageIncomesAmount, totalAmount: totalExpensesAmount + totalIncomesAmount, color: .green)
                                    Text("$\(averageIncomesAmount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.top)
                    .background(Color.sandDark)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                }
            }
        }
        .background(Color.sand)
        .edgesIgnoringSafeArea(.all)
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
        netBalanceAmount = totalIncomesAmount - totalExpensesAmount
        
        // Additional Statistics
        averageExpensesAmount = totalExpensesAmount / Double(expensesViewModel.expenses.count)
        averageIncomesAmount = totalIncomesAmount / Double(incomesViewModel.incomes.count)
        
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
                .font(.title2)
            Text("\(title): $\(amount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Spacer()
        }
        .padding()
        .background(Color.sandDark)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct CircleProgressBar: View {
    var amount: Double
    var totalAmount: Double
    var color: Color
    @State private var percentage: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(color.opacity(0.2))
            
            Circle()
                .trim(from: 0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(color)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: percentage)
        }
        .frame(width: 120, height: 120)
        .onAppear {
            self.percentage = totalAmount > 0 ? amount / totalAmount : 0
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .preferredColorScheme(.light)
    }
}

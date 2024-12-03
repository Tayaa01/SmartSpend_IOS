import SwiftUI

struct AllIncomesView: View {
    @StateObject private var incomesViewModel = IncomesViewModel()
    
    var body: some View {
        VStack {
            if incomesViewModel.isLoading {
                ProgressView("Loading all incomes...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let errorMessage = incomesViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                if incomesViewModel.incomes.isEmpty {
                    Text("No incomes found")
                        .foregroundColor(.gray)
                        .font(.title2)
                        .padding()
                } else {
                    List(incomesViewModel.incomes) { income in
                        IncomeCard(income: income)
                            .padding(.vertical, 5)
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            if let token = UserDefaults.standard.string(forKey: "access_token") {
                incomesViewModel.fetchIncomes(token: token)
            } else {
                incomesViewModel.errorMessage = "User not logged in."
                incomesViewModel.isLoading = false
            }
        }
        .navigationTitle("All Incomes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action to scroll to the top
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.purple)
                        .font(.title2)
                }
            }
        }
    }
}

struct AllIncomesView_Previews: PreviewProvider {
    static var previews: some View {
        AllIncomesView()
    }
}

// Carte de revenu
struct IncomesCard: View {
    var income: Income
    
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
            // Icône de catégorie
            Image(systemName: "dollarsign.circle.fill")
                .font(.title)
                .foregroundColor(.green)
                .frame(width: 40, height: 40)
                .background(Color.green.opacity(0.2))
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            // Détails du revenu
            VStack(alignment: .leading) {
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
                
                HStack {
                    Text("Date:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(formattedDate(from: income.date))
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

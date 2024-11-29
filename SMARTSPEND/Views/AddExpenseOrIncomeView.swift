//
//  AddExpenseOrIncomeView.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 28/11/2024.
//

import SwiftUI

struct AddExpenseOrIncomeView: View {
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var type: String = "Expense"
    @State private var errorMessage: String? = nil
    @State private var isSubmitting: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Add \(type)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Picker("Type", selection: $type) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())
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

                Button(action: addExpenseOrIncome) {
                    if isSubmitting {
                        ProgressView()
                    } else {
                        Text("Add \(type)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                }

                Spacer()
            }
            .navigationTitle("Add \(type)")
        }
    }

    private func addExpenseOrIncome() {
        // Validation de l'input
        guard let amountValue = Double(amount), !description.isEmpty, !category.isEmpty else {
            errorMessage = "Please fill in all fields correctly."
            return
        }
        
        // Préparer l'objet à envoyer
        let expenseOrIncome = ExpenseOrIncome(amount: amountValue, description: description, category: category, type: type)

        // Remplacer "your_token" par le token de l'utilisateur
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            errorMessage = "You need to be logged in."
            return
        }

        isSubmitting = true
        ExpenseService.shared.addExpenseOrIncome(data: expenseOrIncome, token: token) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    // Si la requête réussit, on ferme la vue
                    print("\(type) added successfully!")
                    // Vous pouvez ajouter ici du code pour fermer la vue ou afficher une confirmation
                case .failure(let error):
                    errorMessage = "Failed to add \(type): \(error.localizedDescription)"
                }
            }
        }
    }
}

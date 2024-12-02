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

}

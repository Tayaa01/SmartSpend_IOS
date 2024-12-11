import SwiftUI

struct AddExpenseOrIncomeView: View {
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = ""  // Selected Category ID
    @State private var type: String = "Expense"  // Expense or Income
    @State private var categories: [Category] = []  // List of all categories
    @State private var errorMessage: String? = nil
    @State private var isSubmitting: Bool = false
    @State private var isLoadingCategories: Bool = true  // Loading state for categories
    @Environment(\.dismiss) var dismiss  // Environment to dismiss the view

    var onTransactionAdded: (() -> Void)?  // Callback to notify parent view

    // Filtered categories based on the selected type
    private var filteredCategories: [Category] {
        categories.filter { $0.type == type }
    }

    // Fetch categories from the server
    func fetchCategories() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            self.errorMessage = "Token not found."
            self.isLoadingCategories = false
            return
        }

        let url = URL(string: "http://localhost:3000/categories")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Failed to fetch categories: \(error.localizedDescription)"
                    self.isLoadingCategories = false
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    self.isLoadingCategories = false
                    return
                }

                do {
                    let decodedCategories = try JSONDecoder().decode([Category].self, from: data)
                    self.categories = decodedCategories
                    self.isLoadingCategories = false
                } catch {
                    self.errorMessage = "Failed to decode categories."
                    self.isLoadingCategories = false
                }
            }
        }.resume()
    }

    // Submit the expense or income
    func submitExpenseOrIncome() {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            self.errorMessage = "Token not found."
            return
        }

        guard let amount = Double(amount), amount > 0 else {
            self.errorMessage = "Amount should be greater than zero."
            return
        }

        guard !description.isEmpty, !category.isEmpty else {
            self.errorMessage = "Please fill all fields."
            return
        }

        // Determine the URL based on the selected type
        let baseURL = "http://localhost:3000"
        let endpoint = type == "Expense" ? "expense" : "income"
        let urlString = "\(baseURL)/\(endpoint)?token=\(token)"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL."
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let currentDate = ISO8601DateFormatter().string(from: Date())
        let body: [String: Any] = [
            "amount": amount,
            "description": description,
            "date": currentDate,
            "category": category  // Category ID
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            self.errorMessage = "Failed to create request body."
            return
        }

        isSubmitting = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false

                if let error = error {
                    self.errorMessage = "Failed to submit: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self.errorMessage = nil
                    print("Transaction successfully submitted.")
                    
                    // Notify parent view and dismiss
                    onTransactionAdded?()
                    dismiss()
                    return
                }

                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                }
            }
        }.resume()
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) { // Increased spacing for better layout
                Text("Add \(type)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 120.0) // Increased padding top for more space
                    .foregroundColor(Color.mostImportantColor) // Use your primary color for title

                // Add some vertical padding here to push the segmented picker down
                Spacer().frame(height: 20)

                Picker("Type", selection: $type) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.sandDark) // Darker background for picker
                .cornerRadius(10)
                .padding(.horizontal)

                VStack(spacing: 25) { // Added vertical spacing between TextFields
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.sandDark) // Darker background for text field
                        .cornerRadius(10)
                        .padding(.horizontal)

                    TextField("Description", text: $description)
                        .padding()
                        .background(Color.sandDark) // Darker background for text field
                        .cornerRadius(10)
                        .padding(.horizontal)

                    if !isLoadingCategories {
                        Picker("Category", selection: $category) {
                            Text("Select Category").tag("")
                            ForEach(filteredCategories, id: \.id) { category in
                                Text(category.name).tag(category.id)
                            }
                        }
                        .padding()
                        .background(Color.sandDark) // Darker background for picker
                        .cornerRadius(10)
                        .padding(.horizontal)
                    } else {
                        ProgressView("Loading Categories...")
                            .padding()
                            .foregroundColor(Color.mostImportantColor)
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Button(action: {
                    submitExpenseOrIncome()
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitting ? Color.gray : Color.mostImportantColor) // Background with main theme color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .disabled(isSubmitting)

                Spacer()
            }
            .onAppear {
                fetchCategories()
            }
            .navigationTitle("Add \(type)")
            .background(Color.sand) // Background color of the screen
            .edgesIgnoringSafeArea(.all)
        }
    }

}

// Category model
struct Category: Identifiable, Codable {
    var id: String
    var name: String
    var type: String  // "Expense" or "Income"

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case type
    }
}

struct AddExpenseOrIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseOrIncomeView()
    }
}

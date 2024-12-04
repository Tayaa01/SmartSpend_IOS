import SwiftUI

struct AddExpenseOrIncomeView: View {
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = ""  // Category ID
    @State private var type: String = "Expense"
    @State private var categories: [Category] = []  // List of categories
    @State private var errorMessage: String? = nil
    @State private var isSubmitting: Bool = false
    @State private var isLoadingCategories: Bool = true  // Loading state for categories

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

        let url = URL(string: "http://localhost:3000/expense?token=\(token)")!
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

        print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "N/A")")

        isSubmitting = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isSubmitting = false

                // Handle connection errors
                if let error = error {
                    self.errorMessage = "Failed to submit: \(error.localizedDescription)"
                    return
                }

                // Validate HTTP response
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        self.errorMessage = nil
                        print("Expense successfully submitted.")
                        // Optionally reset form or navigate away
                        return
                    } else {
                        self.errorMessage = "Server error: \(httpResponse.statusCode)"
                        return
                    }
                }

                // Check the API response body for additional validation
                if let data = data {
                    print("Response Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                }
            }
        }.resume()
    }

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

                // Category Picker
                if !isLoadingCategories {
                    Picker("Category", selection: $category) {
                        Text("Select Category").tag("")
                        ForEach(categories, id: \..id) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                } else {
                    ProgressView("Loading Categories...")
                        .padding()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                }

                Button(action: {
                    submitExpenseOrIncome()
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitting ? Color.gray : Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                .disabled(isSubmitting)

                Spacer()
            }
            .onAppear {
                fetchCategories()
            }
            .navigationTitle("Add \(type)")
        }
    }
}

// Category model
struct Category: Identifiable, Codable {
    var id: String
    var name: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct AddExpenseOrIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseOrIncomeView()
    }
}

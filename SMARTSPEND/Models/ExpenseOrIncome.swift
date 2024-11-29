import Foundation

struct ExpenseOrIncome: Codable {
    var amount: Double
    var description: String
    var category: String
    var type: String // "expense" ou "income"
}

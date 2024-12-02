import Foundation

struct Expense: Identifiable, Codable {
    // Utilisez `CodingKeys` pour lier les clés JSON aux propriétés du modèle Swift
    var id: String
    var amount: Double
    var description: String
    var date: String // Vous pouvez aussi utiliser `Date` si vous avez besoin de convertir en date
    var category: String
    var user: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Correspondance entre "_id" dans JSON et "id" dans le modèle Swift
        case amount
        case description
        case date
        case category
        case user
    }
}

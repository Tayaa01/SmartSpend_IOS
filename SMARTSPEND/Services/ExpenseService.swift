import Foundation

class ExpenseService {
    static let shared = ExpenseService()
    
    private let baseURL = "http://localhost:3005/api" // Remplacez par l'URL de votre API

    
   
    // Fonction pour ajouter une dépense ou un revenu
    func addExpenseOrIncome(data: ExpenseOrIncome, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/expense") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encoder les données en JSON
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(data)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        // Envoi de la requête
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Vérifier la réponse HTTP
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "com.error", code: 400, userInfo: nil)))
            }
        }.resume()
    }
}

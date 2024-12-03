//  IncomeService.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 3/12/2024.
//

import Foundation

class IncomeService {
    
    static let shared = IncomeService()
    
    private let baseURL = "http://localhost:3000/income"
    
    // Fonction pour récupérer les revenus
    func fetchIncomes(token: String, completion: @escaping (Result<[Income], Error>) -> Void) {
        // Ajout du token en paramètre d'URL
        guard let url = URL(string: "\(baseURL)?token=\(token)") else {
            print("❌ Erreur : URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // On ne met plus le token dans l'en-tête, car il est désormais dans l'URL.
        
        // Log de la requête
        print("📤 Debug: Requête envoyée à l'URL : \(url)")
        print("📤 Debug: En-têtes de requête : \(request.allHTTPHeaderFields ?? [:])")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Vérification des erreurs de connexion
            if let error = error {
                print("❌ Erreur de connexion : \(error.localizedDescription)")  // Affiche l'erreur si la requête échoue
                completion(.failure(error))
                return
            }
            
            // Vérification de la réponse HTTP
            if let httpResponse = response as? HTTPURLResponse {
                print("📥 Debug: Code de statut HTTP : \(httpResponse.statusCode)")
                print("📥 Debug: En-têtes de la réponse HTTP : \(httpResponse.allHeaderFields)")
                
                if httpResponse.statusCode == 404 {
                    print("❌ Debug: Endpoint introuvable (404). Vérifiez l'URL du serveur backend.")
                    completion(.failure(NSError(domain: "IncomeService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Endpoint introuvable."])))
                    return
                }
            }
            
            // Vérification des données reçues
            guard let data = data else {
                print("❌ Erreur : Aucune donnée reçue")
                completion(.failure(NSError(domain: "IncomeService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue."])))
                return
            }
            
            // Log de la réponse brute (avant décodage)
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 Données JSON brutes reçues: \(rawResponse)")
            }
            
            // Tentative de décodage des données
            do {
                let incomes = try JSONDecoder().decode([Income].self, from: data)
                print("✅ Debug: Décodage réussi ! \(incomes.count) revenus récupérés.")
                completion(.success(incomes))
            } catch {
                print("❌ Erreur de décodage : \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

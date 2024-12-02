//
//  ExpensesViewModel.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 2/12/2024.
//

import SwiftUI

class ExpensesViewModel: ObservableObject {
    @Published var expenses: [Expense] = []  // To store fetched expenses
    @Published var isLoading: Bool = false   // Loading state
    @Published var errorMessage: String?     // Error message in case of failure
    
    // Function to fetch expenses from backend
    func fetchExpenses(token: String) {
        guard let url = URL(string: "http://localhost:3000/expense?token=\(token)") else {
            errorMessage = "URL invalide"
            return
        }

        // Affichage de l'indicateur de chargement
        isLoading = true
        errorMessage = nil

        // Création de la requête réseau
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Exécution de la requête réseau
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Gestion des erreurs réseau
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Erreur réseau: \(error.localizedDescription)"
                    self?.isLoading = false
                }
                return
            }

            // Vérifier la réponse HTTP
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Erreur HTTP: Code \(statusCode)"
                        self?.isLoading = false
                    }
                    return
                }
            }

            // Validation des données reçues
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Aucune donnée reçue."
                    self?.isLoading = false
                }
                return
            }

            // Déboguer les données brutes JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Données JSON brutes reçues: \(jsonString)")
            }

            // Tentative de décodage des données
            do {
                // Tentative de décodage
                let decodedExpenses = try JSONDecoder().decode([Expense].self, from: data)
                DispatchQueue.main.async {
                    self?.expenses = decodedExpenses
                    self?.isLoading = false
                }
            } catch {
                // Affichage détaillé de l'erreur de décodage
                DispatchQueue.main.async {
                    self?.errorMessage = "Échec du décodage des dépenses : \(error.localizedDescription)"
                    self?.isLoading = false
                }
                
                // Affichage détaillé de l'erreur JSON
                print("Erreur lors du décodage JSON: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Données JSON échouées: \(jsonString)")
                }
            }
        }.resume()
    }

}

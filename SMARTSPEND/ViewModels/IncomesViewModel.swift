//  IncomesViewModel.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 3/12/2024.
//

import SwiftUI

class IncomesViewModel: ObservableObject {
    @Published var incomes: [Income] = []  // Liste des revenus
    @Published var isLoading: Bool = true  // Indicateur de chargement
    @Published var errorMessage: String?  // Message d'erreur si la récupération échoue
    var totalIncome: Double {
           incomes.reduce(0) { $0 + $1.amount }
       }

    private let incomeService = IncomeService()  // Instance du service IncomeService
    
    // Méthode pour récupérer les revenus
    func fetchIncomes(token: String) {
        isLoading = true  // Démarre le chargement
        errorMessage = nil  // Réinitialise le message d'erreur
        
        // Passer le token dans l'URL
        incomeService.fetchIncomes(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let incomes):
                    self.incomes = incomes  // Met à jour la liste des revenus
                    self.isLoading = false  // Fin du chargement
                case .failure(let error):
                    // Affiche l'erreur lors de l'échec
                    self.errorMessage = "Erreur lors de la récupération des revenus: \(error.localizedDescription)"
                    self.isLoading = false  // Fin du chargement
                }
            }
        }
    }
}

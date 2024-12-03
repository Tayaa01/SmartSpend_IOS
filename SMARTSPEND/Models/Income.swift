//
//  Income.swift
//  SMARTSPEND
//
//  Created by yassmine zammali on 3/12/2024.
//
import Foundation

// Modèle pour les revenus
struct Income: Identifiable, Codable {
    var id: String  // Identifiant unique du revenu
    var amount: Double  // Montant du revenu
    var description: String  // Description du revenu
    var date: String  // Date du revenu (au format ISO 8601)
    var category: String  // Catégorie du revenu
    var user: String  // Identifiant de l'utilisateur
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Correspondance entre "_id" dans JSON et "id" dans le modèle Swift
        case amount
        case description
        case date
        case category
        case user
    }
}



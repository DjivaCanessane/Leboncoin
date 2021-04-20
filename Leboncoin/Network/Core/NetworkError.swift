//
//  NetworkError.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

enum NetworkError: Error {
    case noData
    case hasError
    case responseIsWrongType
    case wrongStatusCode
    case canNotDecode
    case invalidURL

    var message: String {
        switch self {
        case .noData: return "Aucune donnée."
        case .hasError: return "vérifier votre connexion internet."
        case .responseIsWrongType: return "La réponse réseau est illisible."
        case .wrongStatusCode: return "Le code de la réponse réseau est différent de 200."
        case .canNotDecode: return "Impossible de décoder les données."
        case .invalidURL: return "URL invalide."
        }
    }
}

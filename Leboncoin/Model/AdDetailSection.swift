//
//  AdDetailSection.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 18/04/2021.
//

protocol DisplayHeader: CustomStringConvertible {
    var showHearder: Bool { get }
}

enum AdDetailSection: Int, CaseIterable, DisplayHeader {
    case thumbImage
    case essantialsDetails
    case category
    case description

    var description: String {
        switch self {
        case .thumbImage: return ""
        case .essantialsDetails: return ""
        case .category: return "Catégorie"
        case .description: return "Description"
        }
    }

    var showHearder: Bool {
        switch self {
        case .thumbImage: return false
        case .essantialsDetails: return false
        case .category: return true
        case .description: return true
        }
    }

}

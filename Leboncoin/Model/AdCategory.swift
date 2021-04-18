//  swiftlint:disable identifier_name
//  AdCategory.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import Foundation

typealias AdCategories = [AdCategory]
typealias AdCategoriesDict = [Int: String]

struct AdCategory: Codable {
    let id: Int
    let name: String
}

extension AdCategories {
    func getAdCategoriesDictionary() -> AdCategoriesDict {
        self.reduce(into: [:]) { dictionary, adCategory in
            dictionary[adCategory.id] = adCategory.name
        }
    }
}

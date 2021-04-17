//  swiftlint:disable identifier_name
//  AdCategory.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 17/04/2021.
//

import Foundation

typealias AdCategories = [AdCategory]

struct AdCategory: Codable {
    let id: Int
    let name: String
}

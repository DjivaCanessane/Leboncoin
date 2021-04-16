//  swiftlint:disable identifier_name
//  ItemResult.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

typealias AdsData = [AdData]

struct AdData: Codable {
    let id, categoryID: Int
    let title, description: String
    let price: Float
    let imagesURL: ImagesURL
    let creationDate: String
    let isUrgent: Bool
    let siret: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title
        case description
        case price
        case imagesURL = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
    }
}

struct ImagesURL: Codable {
    let small, thumb: String?
}

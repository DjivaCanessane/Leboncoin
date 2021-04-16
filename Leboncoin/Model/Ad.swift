//  swiftlint:disable type_name identifier_name
//  Item.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

typealias Ads = [Ad]

struct Ad {
    let id: Int
    let creationDate: String
    let title: String
    let description: String
    let categoryID: Int
    let price: Float
    let isUrgent: Bool
    let siret: String?
    let smallImageURLString: String?
    var smallImageData: Data?
    let thumbImageURLString: String?
    var thumbImageData: Data?
}

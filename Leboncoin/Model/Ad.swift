//  swiftlint:disable type_name identifier_name
//  Item.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 13/04/2021.
//

import Foundation

typealias Ads = [Ad]

struct Ad: Codable {
    let id: Int
    let creationDate: Date
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

extension Ads {
    /// Return ads arranged by filtering the urgent ads, then sort them according to creation date
    func arrangeAds() -> Ads {
        var ads: Ads = self

        // Filter ads according to isUrgent, then sort them by creationDate
        var urgentAds: Ads = ads.filter { $0.isUrgent }
        urgentAds.sort { $0.creationDate > $1.creationDate }
        urgentAds.forEach { urgentAd in
            ads.removeAll { ad -> Bool in
                ad.id == urgentAd.id
            }
        }

        ads.sort { $0.creationDate > $1.creationDate }
        let arrangedAds: Ads = urgentAds + ads
        return arrangedAds
    }

    /// Return ads, filtered by categoryID
    func filter(categoryID: Int) -> Ads {
        return self.filter { $0.categoryID == categoryID }
    }
}

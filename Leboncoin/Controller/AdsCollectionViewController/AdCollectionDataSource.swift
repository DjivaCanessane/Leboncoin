//  swiftlint:disable identifier_name
//  AdCollectionDataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

class AdCollectionDataSource: NSObject, UICollectionViewDataSource {

    // MARK: - INTERNAL

    // MARK: Properties

    var ads: Ads
    var adCategoriesDict: AdCategoriesDict

    // MARK: Lifecycle methods

    init(ads: Ads, adCategoriesDict: AdCategoriesDict) {
        self.ads = ads
        self.adCategoriesDict = adCategoriesDict
    }

    // MARK: Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AdCollectionViewCell.identifier,
            for: indexPath
        ) as? AdCollectionViewCell ?? AdCollectionViewCell()

        let ad: Ad = ads[indexPath.row]
        let adCategoryStr: String = adCategoriesDict[ad.categoryID] ?? "Inconnu"
        collectionCell.setup(with: ad, adCategoryStr: adCategoryStr)
        return collectionCell
    }
}

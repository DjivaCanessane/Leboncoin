//  swiftlint:disable identifier_name
//  AdCollectionViewController+DataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

extension AdCollectionViewController: UICollectionViewDataSource {
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

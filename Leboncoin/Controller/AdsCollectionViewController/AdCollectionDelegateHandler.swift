//  swiftlint:disable identifier_name
//  AdCollectionDelegateHandler.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

class AdCollectionDelegateHandler: NSObject, UICollectionViewDelegateFlowLayout {

    // MARK: - INTERNAL

    // MARK: Lifecycle methods

    init(
        screenWidth: CGFloat,
        ads: Ads,
        adCategoriesDict: AdCategoriesDict,
        navigationController: UINavigationController?
    ) {
        self.screenWidth = screenWidth
        self.ads = ads
        self.adCategoriesDict = adCategoriesDict
        self.navigationController = navigationController
    }

    // MARK: Methods

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = (screenWidth / 2) - (spacing * 2)

        return CGSize(width: width, height: width * 2)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return spacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return spacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let adDetailViewController: AdDetailViewController = AdDetailViewController()
        let ad: Ad = ads[indexPath.row]
        adDetailViewController.ad = ad
        adDetailViewController.adDetailCellProvider =
            AdDetailCellProvider(ad: ad, adCategoryName: adCategoriesDict[ad.categoryID] ?? "Inconnu")
        navigationController?.pushViewController(adDetailViewController, animated: true)
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let spacing: CGFloat = 16
    private let screenWidth: CGFloat
    private let ads: Ads
    private let adCategoriesDict: AdCategoriesDict
    private let navigationController: UINavigationController?
}

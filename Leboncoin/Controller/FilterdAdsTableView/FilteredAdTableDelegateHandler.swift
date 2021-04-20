//  swiftlint:disable identifier_name
//  FilteredAdTableDelegateHandler.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

final class FilteredAdTableDelegateHandler: NSObject, UITableViewDelegate {

    // MARK: - INTERNAL

    // MARK: Lifecycle methods

    init(filteredAds: Ads, adCategoriesName: String, navigationController: UINavigationController?) {
        self.filteredAds = filteredAds
        self.adCategoriesName = adCategoriesName
        self.navigationController = navigationController
    }

    // MARK: Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adDetailViewController: AdDetailViewController = AdDetailViewController()
        let ad: Ad = filteredAds[indexPath.row]
        adDetailViewController.ad = ad
        adDetailViewController.adDetailCellProvider =
            AdDetailCellProvider(ad: ad, adCategoryName: adCategoriesName)
        navigationController?.pushViewController(adDetailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let filteredAds: Ads
    private let adCategoriesName: String
    private let navigationController: UINavigationController?
}

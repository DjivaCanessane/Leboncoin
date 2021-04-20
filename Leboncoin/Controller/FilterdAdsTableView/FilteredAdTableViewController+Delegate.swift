//  swiftlint:disable identifier_name
//  FilteredAdTableViewController+Delegate.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

extension FilteredAdTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adDetailViewController: AdDetailViewController = AdDetailViewController()
        let ad: Ad = filteredAds[indexPath.row]
        adDetailViewController.ad = ad
        adDetailViewController.adDetailCellProvider =
            AdDetailCellProvider(ad: ad, adCategoryName: adCategoriesName)
        navigationController?.pushViewController(adDetailViewController, animated: true)
    }
}

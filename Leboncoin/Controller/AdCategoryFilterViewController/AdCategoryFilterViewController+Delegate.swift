//
//  AdCategoryFilterViewController+Delegate.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

extension AdCategoryFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategoryID: Int = indexPath.row + 1
        let selectedCategoryName: String = adCategoriesDict[selectedCategoryID] ?? "Inconnu"
        let filteredAds: Ads = ads.filter(categoryID: selectedCategoryID)

        let filteredAdTableViewController: FilteredAdTableViewController = FilteredAdTableViewController()
        filteredAdTableViewController.filteredAds = filteredAds
        filteredAdTableViewController.adCategoriesName = selectedCategoryName

        navigationController?.dismiss(animated: true) { [self] in
            delegate?.pushWhenModalIsDismissed(filteredAdTableViewController: filteredAdTableViewController)
        }
    }
}

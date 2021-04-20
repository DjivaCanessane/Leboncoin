//
//  AdCategoryFilterDelegateHandler.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

protocol AdCategoryFilterViewDelegate: AnyObject {
    func pushWhenModalIsDismissed(filteredAdTableViewController: FilteredAdTableViewController)
}

class AdCategoryFilterDelegateHandler: NSObject, UITableViewDelegate {

    // MARK: - INTERNAL

    // MARK: Properties

    weak var delegate: AdCategoryFilterViewDelegate?

    // MARK: Lifecycle methods

    init(adCategoriesDict: AdCategoriesDict, ads: Ads, navigationController: UINavigationController?) {
        self.adCategoriesDict = adCategoriesDict
        self.ads = ads
        self.navigationController = navigationController
    }

    // MARK: Methods

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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let adCategoriesDict: AdCategoriesDict
    private let ads: Ads
    private let navigationController: UINavigationController?
}

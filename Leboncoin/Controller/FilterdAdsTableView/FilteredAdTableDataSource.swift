//  swiftlint:disable identifier_name
//  FilteredAdTableDataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

final class FilteredAdTableDataSource: NSObject, UITableViewDataSource {

    // MARK: - INTERNAL

    // MARK: Lifecycle methods

    init(filteredAds: Ads) {
        self.filteredAds = filteredAds
    }

    // MARK: Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: AdTableViewCell.identifier,
            for: indexPath
        ) as? AdTableViewCell ?? AdTableViewCell()

        let ad: Ad = filteredAds[indexPath.row]
        tableViewCell.setup(with: ad)
        return tableViewCell
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let filteredAds: Ads
}

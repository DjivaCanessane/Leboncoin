//  swiftlint:disable identifier_name
//  FilteredAdTableViewController+DataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

extension FilteredAdTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAds.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
}

//
//  AdCategoryFilterViewController+DataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

extension AdCategoryFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adCategoriesDict.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: UITableViewCell = UITableViewCell()
        tableViewCell.textLabel?.font = .boldSystemFont(ofSize: 18)
        tableViewCell.textLabel?.textColor = .darkGray
        tableViewCell.textLabel?.text = adCategoriesDict[indexPath.row + 1]
        tableViewCell.accessoryType = .disclosureIndicator
        return tableViewCell
    }
}
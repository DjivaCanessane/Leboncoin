//
//  AdDetailViewController+DataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 19/04/2021.
//

import UIKit

extension AdDetailViewController: UITableViewDataSource {

    // MARK: - Section methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return AdDetailSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOFRowInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        guard let adDetailSection = AdDetailSection(rawValue: section) else { return nil }

        let headerTitleLabel: UILabel = UILabel()
        headerTitleLabel.textColor = .black
        headerTitleLabel.font = .boldSystemFont(ofSize: 22)

        switch adDetailSection {
        case .thumbImage: return nil
        case .essantialsDetails: return nil
        case .category: headerTitleLabel.text = adDetailSection.description
        case .description: headerTitleLabel.text = adDetailSection.description
        }

        headerView.addSubview(headerTitleLabel)

        // headerTitleLabel Constraints
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerTitleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let adDetailSection = AdDetailSection(rawValue: section) else { return .zero }

        switch adDetailSection {
        case .thumbImage: return .zero
        case .essantialsDetails: return .zero
        case .category: return 36
        case .description: return 36
        }
    }

    // MARK: - Row methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return .zero }

        switch adDetailSection {
        case .thumbImage: return view.bounds.width
        case .essantialsDetails: return 160
        case .category: return 30
        case .description: return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch adDetailSection {
        case .thumbImage: return adDetailCellProvider.getThumbImageCell(
            adForThumbImage: ad,
            width: view.bounds.width
        )
        case .essantialsDetails: return adDetailCellProvider.getEssentialDetailsCell()
        case .category: return adDetailCellProvider.getCategoryCell()
        case .description: return adDetailCellProvider.getDescriptionCell()
        }
    }
}

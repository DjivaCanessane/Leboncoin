//
//  AdDetailDelegateHandler.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 20/04/2021.
//

import UIKit

class AdDetailDelegateHandler: NSObject, UITableViewDelegate {

    // MARK: - INTERNAL

    // MARK: Lifecycle methods

    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }

    // MARK: Methods

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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return .zero }

        switch adDetailSection {
        case .thumbImage: return screenWidth
        case .essantialsDetails: return 160
        case .category: return 30
        case .description: return 100
        }
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let screenWidth: CGFloat
}

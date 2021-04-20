//  swiftlint:disable identifier_name
//  AdDetailDataSource.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 19/04/2021.
//

import UIKit

final class AdDetailDataSource: NSObject, UITableViewDataSource {

    // MARK: - INTERNAL

    // MARK: Properties

    var ad: Ad

    // MARK: Lifecycle methods

    init(ad: Ad, screenWidth: CGFloat, adDetailCellProvider: AdDetailCellProvider) {
        self.ad = ad
        self.screenWidth = screenWidth
        self.adDetailCellProvider = adDetailCellProvider
    }

    // MARK: Section methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return AdDetailSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOFRowInSection section: Int) -> Int {
        return 1
    }

    // MARK: Row methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let adDetailSection = AdDetailSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch adDetailSection {
        case .thumbImage: return adDetailCellProvider.getThumbImageCell(
            adForThumbImage: ad,
            width: screenWidth
        )
        case .essantialsDetails: return adDetailCellProvider.getEssentialDetailsCell()
        case .category: return adDetailCellProvider.getCategoryCell()
        case .description: return adDetailCellProvider.getDescriptionCell()
        }
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let screenWidth: CGFloat
    private let adDetailCellProvider: AdDetailCellProvider
}

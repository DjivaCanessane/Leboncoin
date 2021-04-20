//  swiftlint:disable identifier_name
//  AdDetailViewController.swift
//  Leboncoin
//
//  Created by Djiveradjane Canessane on 18/04/2021.
//

import UIKit

final class AdDetailViewController: UIViewController {

    // MARK: - INTERNAL

    // MARK: Properties

    var ad: Ad!
    var adDetailCellProvider: AdDetailCellProvider!

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getThumbImage()
        configureTableView()
        title = "Détails"
    }

    // MARK: - PRIVATE

    // MARK: Properties

    private let tableView: UITableView = UITableView()
    private let adNetworkManager: AdNetworkManager = AdNetworkManager.shared
    private lazy var adDetailDelegateHandler: AdDetailDelegateHandler =
        AdDetailDelegateHandler(screenWidth: view.bounds.width)

    private lazy var adDetailDataSource: AdDetailDataSource = AdDetailDataSource(
        ad: ad,
        screenWidth: view.bounds.width,
        adDetailCellProvider: adDetailCellProvider
    )

    // MARK: Methods

    private func getThumbImage() {
        adNetworkManager.getThumbImage(for: ad) { [weak self] in
            guard let self = self else { return }
            self.ad.thumbImageData = $0
            self.adDetailDataSource.ad.thumbImageData = $0
            self.tableView.reloadData()
        }
    }

    private func configureTableView() {
        tableView.delegate = adDetailDelegateHandler
        tableView.dataSource = adDetailDataSource
        tableView.allowsSelection = false

        view.addSubview(tableView)
        tableView.frame = view.frame

        // To avoid unnecessary tableView's sepators
        tableView.tableFooterView = UIView()
    }
}
